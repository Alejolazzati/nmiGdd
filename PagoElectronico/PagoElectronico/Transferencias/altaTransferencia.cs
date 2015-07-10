using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Transferencias
{
    public partial class nuevaTransferencia
        : Form
    {
        String cuenta;
        public nuevaTransferencia(String cuent)
        {
            cuenta = cuent;
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "execute dbo.transferir " + cuenta + "," + textBox3.Text + "," + textBox2.Text/*+",'"+Program.fecha+"'"*/;
            try { comando.ExecuteNonQuery();
            MessageBox.Show("Transferencia exitosa");
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
                new PagoElectronico.Login.Funcionalidades(1).Show();
                this.Close();
       
            }
            
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            new PagoElectronico.Login.Funcionalidades(1).Show();
            this.Close();
        }

       
    }
}
