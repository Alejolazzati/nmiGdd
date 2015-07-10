using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cliente
{
    public partial class altaCliente : Form
    {
        public altaCliente()
        {
            string nombre;
            string apellido;

            InitializeComponent();
        }

        private void altaCliente_Load(object sender, EventArgs e)
        {

        }

        private void groupBox2_Enter(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox11_TextChanged(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
         //   comando.CommandText = "execute dbo.transferir " + cuenta + "," + textBox3.Text + "," + textBox2.Text + ",'" + Program.fecha + "'";
           
            comando.ExecuteNonQuery();
               
        }
    }
}
