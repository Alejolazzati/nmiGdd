using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Rol
{
    public partial class Rol : Form
    {

        String rol;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public Rol()
        {
            InitializeComponent();
            comando.CommandText = "Select nombre_rol from NMI.Rol";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
               listBox1.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            rol = listBox1.SelectedItem.ToString();
            new modificarRol(rol).Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Rol.formRol().Show();
        }

        private void button3_Click(object sender, EventArgs e)
        {

        }

    }
}
