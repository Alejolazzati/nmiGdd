using System;
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
        public static String nombre;
        String pass;

        public login()
        {
            InitializeComponent();
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
            //Caso intento de login
            if (textBox1.Text.Length == 0) { MessageBox.Show("Complete el username"); return; }
            if (textBox2.Text.Length == 0) { MessageBox.Show("Complete la password"); return; }

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            string contraseniaEncriptada = Encriptar.SHA256(pass);
            Console.WriteLine(contraseniaEncriptada);
            comando.CommandText = "execute NMI.loguear '" + nombre + "','" + contraseniaEncriptada + "'";
            try
            {
                comando.ExecuteNonQuery();
                PagoElectronico.Login.elegirRol elegirRol = new PagoElectronico.Login.elegirRol();
                elegirRol.llamar(nombre);
            }
            catch (System.Data.SqlClient.SqlException er)
            { //recibe posibles excepciones de loggeo
                MessageBox.Show(er.Message);
                new PagoElectronico.Login.login().Show();
            }
            
            this.Close();
            this.Hide();
            
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {   //Caso recuperar contraseña
            if (textBox1.Text.Length > 0)
            {
                nombre = textBox1.Text;
                new PagoElectronico
                .Login
                .Recuperar_contraseña(nombre).Show();
            }
            else { MessageBox.Show("Ingrese UserName"); }


        }      
    }
}
