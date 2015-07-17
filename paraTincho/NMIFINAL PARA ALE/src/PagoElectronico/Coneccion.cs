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
        {
            //string fechaDelSistema = Properties.Settings.Default.fechaDelSistema;
            SqlConnection cone = new SqlConnection(PagoElectronico.Properties.Settings.Default.GD1C2015ConnectionString);
            cone.Open();
            return cone;
        }
        public static SqlCommand getComando()
        {

            return com;
        }
        public static SqlCommand comando()
        {
            SqlCommand comand = new SqlCommand();
            comand.Connection = con;
            return comand;
        }
        /* public static SqlDataAdapter getAdapter()
         {
             SqlDataAdapter adapter = new SqlDataAdapter(con);
        
         }*/



    }
}
