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
    public partial class buscarUsuario : Form
    {
        public buscarUsuario()
        {
            InitializeComponent();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            listBox1.Items.Clear();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            if (textBox1.Text.Length == 0) { MessageBox.Show("Complete la contraseña"); return; }
            comando.CommandText = "Select * from NMI.usernamesParecidos('"+textBox1.Text+"')";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlString(0));
            }


            reader.Dispose();
        }

        private void buscarUsuario_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            try { new PagoElectronico.ABM_de_Usuario.modificarUsuario(listBox1.SelectedItem.ToString()).Show();
            this.Close();
            }
            catch (NullReferenceException ex)
            {
                MessageBox.Show("debe seleccionar un usuario de la lista");
            
            }
            

        }

        private void button2_Click(object sender, EventArgs e)
        {
            new Login.Funcionalidades().Show();
            this.Close();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            new altaUsuario().Show();
            this.Close();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (listBox1.SelectedItem != null)
            {
                String usuarioABorrar;
                usuarioABorrar = listBox1.SelectedItem.ToString();
                System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
                comando.CommandText = "Update nmi.usuario set Estado='baja' where useranme='" + usuarioABorrar + "'";
                comando.ExecuteNonQuery();
                MessageBox.Show("Usuario dado de baja");
                new Login.Funcionalidades().Show();
            }
            else { MessageBox.Show("Elija un usuario"); }


        }
    }
}
