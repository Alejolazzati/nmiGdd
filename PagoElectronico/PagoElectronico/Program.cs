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
            fecha = "20151025";
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());
          //  fecha=PagoElectronico.Properties.Settings.Default.fechaDelSistema;
            new PagoElectronico.Login.login().Show();
            Application.Run();
            

        }

        public static void end(){
            Application.Exit();
        }
    }
}