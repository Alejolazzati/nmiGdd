﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using PagoElectronico.Login;


namespace PagoElectronico
{
    static class Program
    {   
        public static int rol;
        public static System.Data.SqlTypes.SqlDecimal factura;
        public static String fecha;
        public static Int32 cliente;
        public static String cuenta;
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {

          Application.EnableVisualStyles();
          Application.SetCompatibleTextRenderingDefault(false);
          //leer fecha del archivo de config y pasarsela al server  
          fecha=PagoElectronico.Properties.Settings.Default.fechaDelSistema;
          System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
          comando.CommandText = "exec NMI.setFecha '" + fecha + "'";
          comando.ExecuteNonQuery();
          //comienza la ejecucion con el login
          new PagoElectronico.Login.login().Show();
          Application.Run();
        }

        public static void end(){
            Application.Exit();
        }
    }
}