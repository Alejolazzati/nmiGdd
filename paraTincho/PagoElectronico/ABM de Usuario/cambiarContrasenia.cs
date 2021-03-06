﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_de_Usuario
{
    public partial class cambiarContrasenia : Form
    {
        int user;
        public cambiarContrasenia(int us)
        {
            user = us;
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text.Length == 0) { MessageBox.Show("Complete la contraseña"); return; }
            if (textBox2.Text.Length == 0) { MessageBox.Show("Repita la contraseña"); return; }
            String pasword1 = textBox1.Text;
            String pasword2 = textBox2.Text;
           
            if (pasword2 != pasword1)
            {
                MessageBox.Show("No coinciden nuevas contraseñas");
                new cambiarContrasenia(user).Show();
                this.Close();
                return;

            }
            System.Data.SqlClient.SqlCommand comando=Coneccion.getComando();
            pasword1 = Encriptar.SHA256(pasword1);
            comando.CommandText = "execute NMI.nuevaContrasenia " + user + ",'"  + pasword1 + "'";
            try
            {
                
                comando.ExecuteNonQuery();
                MessageBox.Show("Contraseña actualizada");
                this.Close();
            }
            catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }
        }
        }
    }

