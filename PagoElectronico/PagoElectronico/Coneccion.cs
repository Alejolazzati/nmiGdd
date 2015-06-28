using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace PagoElectronico
{
    class Coneccion
    {
        public static SqlConnection conectarBase()
        {
      
        string conectar = @"Data source = john-vaio\sqlserver2008; Initial Catalog = GD1C2015; Trusted_Connection = YES";
        SqlConnection cone = new SqlConnection(conectar);
        cone.Open();
        return cone;
        }

    }
}
