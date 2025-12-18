using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceUser
{
    public interface IDenunciaApiClient
    {
        void DeletDenunciaByUserIdAsync(int userId);
    }
}
