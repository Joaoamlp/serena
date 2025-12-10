using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceDenuncia
{
    internal class PagedResult
    {
        public interface IFormFileWrapper
        {
            string FileName { get; }
            string ContentType { get; }
            long Length { get; }
            Stream OpenReadStream();
        }
    }
}
