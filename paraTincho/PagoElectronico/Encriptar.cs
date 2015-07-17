using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

namespace PagoElectronico
{
    class Encriptar
    {
        public static string SHA256(string texto)
        {
            SHA256 sha256 = SHA256CryptoServiceProvider.Create();
            Byte[] hash = sha256.ComputeHash(ASCIIEncoding.Default.GetBytes(texto));
            StringBuilder cadena = new StringBuilder();
            foreach (byte b in hash)
            {
                cadena.AppendFormat("{0:x2}", b);
            }
            return cadena.ToString();
        }
    }
}
