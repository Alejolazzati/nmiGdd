using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace PagoElectronico
{
    class Coneccion
    {
        
        static System.Data.SqlClient.SqlConnection con = conectarBase();
        static SqlCommand com = comando();
        public static SqlConnection conectarBase()
        {string conectar = @"Data source = localhost\SQLSERVER2008; Initial Catalog = GD1C2015; Trusted_Connection = YES;User=gd;Password=gd2015";
        SqlConnection cone = new SqlConnection(conectar);
        cone.Open();
        return cone;
        }
        public static SqlCommand getComando()
        {    
                       
            return com;
        }
        public static SqlCommand comando()
        {SqlCommand comand=new SqlCommand();
        comand.Connection = con;
            return comand;
        }
       /* public static SqlDataAdapter getAdapter()
        {
            SqlDataAdapter adapter = new SqlDataAdapter(con);
        
        }*/



    }
}
