using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Depositos
{
    public partial class altaDeposito : Form
    {
        public altaDeposito()
        {
            InitializeComponent();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from NMI.cuentasPorCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

            comando.CommandText = "select NMI.Moneda.Descripcion from NMI.Moneda";
            reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();

            comando.CommandText = "Select * from NMI.tarjetasPorCliente(" + Program.cliente + ")";
            reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

            maskedTextBox1.Mask = "0999999999999999999999999999";

            textBox2.Text = Properties.Settings.Default.fechaDelSistema; 
        }

        private void altaDeposito_Load(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {
            
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            String cuenta = listBox2.SelectedItem.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select NMI.saldoCuenta(" + cuenta + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox3.Text = reader.GetSqlValue(0).ToString();
            reader.Dispose();
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void maskedTextBox1_MaskInputRejected(object sender, MaskInputRejectedEventArgs e)
        {

        }
        private void maskedTextBox1_Validating(object sender, CancelEventArgs e)
        {
            e.Cancel = int.Parse(maskedTextBox1.Text) > 0;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            PagoElectronico.Login.Funcionalidades formFuncion = new PagoElectronico.Login.Funcionalidades();
            formFuncion.Show();
        }
    }
}
