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

    public partial class altaCuentaPorCliente : Form
    {
        String numCuenta;
        System.DateTime fechaElegida;
        String pais;
        String moneda;
        String tipo;

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
           
        public altaCuentaPorCliente()
        {
            InitializeComponent();

            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox3.DropDownStyle = ComboBoxStyle.DropDownList;
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

        private void altaCuentaPorCliente_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            numCuenta = maskedTextBox1.Text;
            pais = comboBox3.SelectedItem.ToString();
            moneda = comboBox1.SelectedItem.ToString();
            tipo = comboBox2.SelectedItem.ToString();


        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
           new Form1(this).Show();
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox4.Text = unaFecha.ToShortDateString();
        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


    }
}
