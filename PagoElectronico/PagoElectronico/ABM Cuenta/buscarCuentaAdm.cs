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
        String userName;
        public buscarCuentaAdm()
        {
            InitializeComponent();
        }

        private void button9_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Cuenta.altaCuentaPorAdm().Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            userName = textBox3.Text;
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from usuernamesParecidos(" + userName + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {
            
        }

        private void button3_Click(object sender, EventArgs e)
        {
            userName = listBox1.SelectedItem.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from cuentasPorUsuario(" + userName + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

        }
    }
}
