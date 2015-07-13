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
            
            new modificarCuentaAdm(listBox2.SelectedItem.ToString()).Show();
        }

        private void buscarCuentaAdm_Load(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            comando.CommandText = "select id_cliente from nmi.cliente join nmi.Usuario on (id_usuario=cod_usuario) where nmi.Usuario.useranme='" + listBox1.SelectedItem.ToString() + "'";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            int id_cliente = reader.GetInt32(0);
            reader.Dispose();

            comando.CommandText = "Select * from NMI.cuentasPorCliente(" + id_cliente + ")";
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
            while (reader2.Read())
            {
                listBox2.Items.Add(reader2.GetSqlValue(0));

            }
            this.Show();
            reader2.Dispose();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            String cuenta = listBox2.SelectedItem.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "exec NMI.bajaCuenta " + cuenta;
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Operacion exitosa");
            }
            catch (System.Data.SqlClient.SqlException er)
            { MessageBox.Show(er.Message); }
            
        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {
            new PagoElectronico.Login.Funcionalidades().Show();
            this.Close();
        }
    }
}
