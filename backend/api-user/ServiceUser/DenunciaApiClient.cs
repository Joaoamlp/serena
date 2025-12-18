using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceUser
{
    public class DenunciaApiClient: IDenunciaApiClient
    {
        private readonly HttpClient _http;
        private static readonly TimeSpan CacheTtl = TimeSpan.FromSeconds(30);

        public DenunciaApiClient(HttpClient http)
        {
            _http = http;
        }

        public async void DeletDenunciaByUserIdAsync(int userId)
        {
            try
            {
                if (userId <= 0)
                {
                    throw new ArgumentException("UsuarioId inválido para deleção de denúncias.");
                }

                var resp = await _http.GetAsync($"/api/denuncias/DeleteUser/{userId}");
                if (!resp.IsSuccessStatusCode)
                {
                    var error = await resp.Content.ReadAsStringAsync();
                    throw new ApplicationException($"Erro ao deletar as denuncias: {error}");
                }
            }
            catch (HttpRequestException ex)
            {
                throw new HttpRequestException("Erro ao chamar serviço de denúncias.", ex);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Erro ao deletar as denúncias do usuário.", ex);
            }
        }
    }
}
