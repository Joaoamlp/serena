using Microsoft.Extensions.Caching.Memory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace ServiceDenuncia
{
    public class UserApiClient: IUserApiClient
    {
        private readonly HttpClient _http;
        private readonly IMemoryCache _cache;
        private static readonly TimeSpan CacheTtl = TimeSpan.FromSeconds(30);

        public UserApiClient(HttpClient http, IMemoryCache cache)
        {
            _http = http;
            _cache = cache;
        }

        public async Task<bool> UserExistsAsync(int userId)
        {
            if (userId <= 0) return false;

            var cacheKey = $"user_exists_{userId}";
            if (_cache.TryGetValue(cacheKey, out bool exists))
                return exists;

            try
            {
                // Assume endpoint GET /api/users/{id}/exists returns 200 (exists) or 404 (not exists)
                var resp = await _http.GetAsync($"/api/User/{userId}");

                exists = resp.StatusCode == HttpStatusCode.OK;
                // opcionalmente: handle 204, 403, etc.

                // cache the boolean
                _cache.Set(cacheKey, exists, CacheTtl);

                return exists;
            }
            catch (OperationCanceledException) // timeout or cancellation
            {
                throw new TimeoutException("Timeout ao validar usuário no serviço de usuários.");
            }
            catch (HttpRequestException)
            {
                // serviço indisponível ou erro de rede
                throw new ApplicationException("Erro ao chamar serviço de usuários.");
            }
        }
    }
}

