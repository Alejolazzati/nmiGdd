﻿using System;
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

        string nombre;
        string apellido;
        DateTime fechaElegida;
        string numeroDoc;
        String mail;
        string domicilio;
        string piso;
        string depto;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public altaCliente()
           {
            InitializeComponent();
            comando.CommandText = "Select * from documentosDisponibles()";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           
            
            //CARGAR NACIONALIDADES

            comando.CommandText = "Select * from getNacionalidades()";
            
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           


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
            new Calendario(this).Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            nombre = textBox11.Text;
            apellido = textBox1.Text;
            numeroDoc = textBox10.Text;
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            piso = textBox7.Text;
            depto = textBox4.Text;
            //TIPO DOC
            //NACIONALIDAD


            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
         //   comando.CommandText = "execute dbo.transferir " + cuenta + "," + textBox3.Text + "," + textBox2.Text + ",'" + Program.fecha + "'";
           
            comando.ExecuteNonQuery();
               
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox13.Text = unaFecha.ToShortDateString();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox10_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged_1(object sender, EventArgs e)
        {

        }

        private void textBox9_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox8_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox7_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox13_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
