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
            try { new PagoElectronico.ABM_de_Usuario.modificarUsuario(listBox1.SelectedItem.ToString()).Show(); }
            catch (NullReferenceException ex)
            {
                MessageBox.Show("debe seleccionar un usuario de la lista");
            
            }

        }
    }
}
