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
    public partial class Recuperar_contraseña : Form
    {

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
        String preguntaSecreta;
        String username;

        public Recuperar_contraseña(string userName)
        {
            username = userName;
            InitializeComponent();
        }

        private void Recuperar_contraseña_Load(object sender, EventArgs e)
        {   //conseguir la pregunta secreta del usuario
            comando.CommandText = "Select pregunta_secreta from NMI.usuario where useranme='" + username + "'";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            if (reader.Read())
                preguntaSecreta = reader.GetString(0);
            else 
                //si no hay pregunta secreta para el usuario, es porque no existe
            { 
                MessageBox.Show("Usuario es incorrecto");
                this.Close();
            }
            reader.Dispose();
            textBox1.Text = preguntaSecreta;

        }
                

        private void button1_Click(object sender, EventArgs e)
        { //intento de restablecer datos
            if (textBox2.Text.Length == 0) { MessageBox.Show("Complete la respuesta secreta"); return; }
            if (textBox3.Text.Length == 0) { MessageBox.Show("Complete la nueva contraseña"); return; }
            if (textBox4.Text.Length == 0) { MessageBox.Show("Repita la nueva contraseña"); return; }
            string pasword1;
            string pasword2;
            string respuestaSecreta = Encriptar.SHA256(textBox2.Text);
            pasword1 = textBox3.Text;
            pasword2 = textBox4.Text;
            if (pasword2 != pasword1)
            {
                MessageBox.Show("no coinciden nuevas contraseñas");
                new Recuperar_contraseña(username).Show();
                this.Close();
                return;

            }
            pasword1 = Encriptar.SHA256(textBox3.Text);
            Console.WriteLine(respuestaSecreta);
            Console.WriteLine(pasword1);

            comando.CommandText = "execute NMI.nuevaContra '" + username + "','" + respuestaSecreta + "','" + pasword1 + "'";
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