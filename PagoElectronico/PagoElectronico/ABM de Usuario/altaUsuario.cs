using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_de_Usuario
{
    public partial class altaUsuario : Form
    {
        public altaUsuario()
        {
            InitializeComponent();

            //cargo los roles al comboBox

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select nombre_rol from NMI.Rol";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }


            reader.Dispose();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            //al confirmar

            //validaciones
            if (textBox11.Text.Length == 0) { MessageBox.Show("Complete la contraseña"); return; }
            if (textBox11.Text != textBox1.Text) { MessageBox.Show("Las contraseñas no coinciden entre si"); return; }
            if (textBox12.Text.Length == 0) { MessageBox.Show("Complete el nombre del usuario"); return; }
            if (textBox8.Text.Length == 0) { MessageBox.Show("Complete la pregunta secreta"); return; }
            if (textBox7.Text.Length == 0) { MessageBox.Show("Complete la respuesta secreta"); return; }
            if (comboBox2.SelectedItem == null) { MessageBox.Show("Elija un rol para el usuario"); return; }
            //encriptar los datos
            String pass=Encriptar.SHA256(textBox1.Text);
            String resp = Encriptar.SHA256(textBox7.Text);

            //conseguir el id_rol
            int rol;
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select id_rol from NMI.Rol where nombre_rol='"+comboBox2.SelectedItem.ToString()+"'";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            rol=Int32.Parse(reader.GetSqlValue(0).ToString());
            reader.Dispose();
            

            //ingresar usuario en la base
            try
            {
                comando.CommandText = "Begin transaction exec NMI.ingresarUsuario '" + textBox12.Text + "','" + pass + "','" + textBox8.Text + "','" + resp + "'," + 1;
                comando.ExecuteNonQuery();

                comando.CommandText = "select id_usuario from NMI.Usuario where useranme='" + textBox12.Text + "'";
                reader = comando.ExecuteReader();
                reader.Read();
                Int32 id_user = Int32.Parse(reader.GetSqlValue(0).ToString());
                reader.Dispose();

                comando.CommandText = "update nmi.usuario_rol set cod_rol=" + rol + " where cod_usuario=" + id_user + " commit";
                comando.ExecuteNonQuery();

                MessageBox.Show("Alta correcta");
                new Login.Funcionalidades().Show();
                this.Close();

            }
            catch (System.Data.SqlClient.SqlException er) {MessageBox.Show(er.Message);}
            
        
        }

        private void button1_Click(object sender, EventArgs e)
        {
            new Login.Funcionalidades().Show();
            this.Close();
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

      
       
    }
}
