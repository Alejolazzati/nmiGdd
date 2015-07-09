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
    public partial class buscarCuentaCliente : Form
    {
        public buscarCuentaCliente()
        {
            InitializeComponent();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from cuentasPorCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();



        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            String cuenta = listBox2.SelectedItem.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select dbo.saldoCuenta(" + cuenta + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox1.Text = reader.GetSqlValue(0).ToString();
            reader.Dispose();
        }

        private void buscarCuentaCliente_Load(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {

            PagoElectronico.Login.Funcionalidades funci = new PagoElectronico.Login.Funcionalidades(1);
            funci.Show();
            this.Close();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            String cuenta = listBox2.SelectedItem.ToString();
            new PagoElectronico.ABM_Cuenta.modificarCuentaCliente(cuenta).Show();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Cuenta.altaCuentaPorCliente().Show();
        }
    }
}
