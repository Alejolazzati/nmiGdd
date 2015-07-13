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
    public partial class altaCuentaPorAdm : Form
    {

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();

        String userName;
        String numCuenta;
        String pais;
        String moneda;
        DateTime fechaApertura;
        String categoria;

        public altaCuentaPorAdm()
        {
            InitializeComponent();

            //cargar paises
            comando.CommandText = "Select descripcion from NMI.pais";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox3.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();

            //cargar moneda


            comando.CommandText = "Select descripcion from NMI.MONEDA";
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
            while (reader2.Read())
            {
                comboBox1.Items.Add(reader2.GetSqlString(0));

            }
            this.Show();
            reader2.Dispose();


            // cargar categoria


            comando.CommandText = "Select descripcion from NMI.categoria";
            System.Data.SqlClient.SqlDataReader reader3 = comando.ExecuteReader();
            while (reader3.Read())
            {
                comboBox2.Items.Add(reader3.GetSqlString(0));

            }
            this.Show();
            reader3.Dispose();

            maskedTextBox1.Mask = "0999999999999999999999999999";


        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            comando.CommandText = "Select * from NMI.usernamesParecidos('" + textBox3.Text + "')";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();

        }

        private void button3_Click(object sender, EventArgs e)
        {
            userName = listBox1.SelectedItem.ToString();
        }

        private void altaCuentaPorAdm_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            new Form2(this).Show();

        }

        public void recibirFecha(DateTime unaFecha)
        {
            fechaApertura = unaFecha;
            textBox4.Text = unaFecha.ToShortDateString();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Haceme");
            userName = listBox1.SelectedItem.ToString();
            //ver si hace falta el Id_cliente
            numCuenta = maskedTextBox1.Text;
            pais = comboBox3.SelectedItem.ToString();
            moneda = comboBox1.SelectedItem.ToString();
            categoria = comboBox2.SelectedItem.ToString();


            /*
             *             comando.CommandText = "exec sarasa "
            comando.ExecuteNonQuery(); 

		try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Operacion exitosa");
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
            }
             */
        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged_1(object sender, EventArgs e)
        {
            
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
