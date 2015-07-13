using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cuenta
{
    public partial class buscarCuentaAdm : Form
    {
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
        
        public buscarCuentaAdm()
        {
            InitializeComponent();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            //buscar usernamesParecidos

            comando.CommandText = "Select * from NMI.usernamesParecidos('" + textBox3.Text + "')";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();

           
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            new altaCuentaPorAdm().Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            long numCuentaTru=1111111111111111;
            new modificarCuentaAdm(numCuentaTru.ToString()).Show();
        }
    }
}
