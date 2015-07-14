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
        {
            comando.CommandText = "Select pregunta_secreta from NMI.usuario where useranme='" + username + "'";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            if (reader.Read())
                preguntaSecreta = reader.GetString(0);
            else
            {
                MessageBox.Show("Usuario es incorrecto");
                this.Close();
            }
            reader.Dispose();
            textBox1.Text = preguntaSecreta;

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            
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
            comando.CommandText = "execute NMI.nuevaContra '" + username + "','" + respuestaSecreta + "','" + pasword1 + "'";
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Contraseña actualizada");
            }
            catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }
    }

}