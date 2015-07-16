using System;
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

            //string fede = Encriptar.SHA256("respuestaSecreta");
            // Console.WriteLine(fede);     ¡NO BORRAR ESTOS COMENTARIOS!
            //867591a1b127029f1ff8186740cbea1f8eca76479b6f7f59853a695061fda464='respuestaSecreta'
         //    ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb='a'
        //    f46e3b17a6b639e5efddc3d1498ad73491599c22220f7ef6e14772f4ee25b913='texto'
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());
          fecha=PagoElectronico.Properties.Settings.Default.fechaDelSistema;
          System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
          comando.CommandText = "exec NMI.setFecha '" + fecha + "'";
          comando.ExecuteNonQuery();
          new PagoElectronico.Login.login().Show();
          Application.Run();
           

        }

        public static void end(){
            Application.Exit();
        }
    }
}