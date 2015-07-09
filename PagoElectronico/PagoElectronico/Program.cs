using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using PagoElectronico.Login;

namespace PagoElectronico
{
    static class Program
    {

        public static Int32 cliente;
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());

            login unLogin = new Login.login();
             unLogin.Show();
            Application.Run();
            

        }

        public static void end(){
            Application.Exit();
        }
    }
}