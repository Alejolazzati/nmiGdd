﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Login
{
    public partial class login : Form
    {
        String nombre;
        String pass;
        public login()
        {
            InitializeComponent();
        }

        private void login_Load(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            nombre = textBox1.Text;
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {
            pass = textBox2.Text;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //pegar a base si no esta, error, si esta ir a elegir rol
            //PagoElectronico.ERROR unError = new PagoElectronico.ERROR();
            //unError.Mostrar("Datos incorrectos");
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select * from Estado_transaccion";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(1));




            }

            reader.Dispose();
            
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


        
    }
}
