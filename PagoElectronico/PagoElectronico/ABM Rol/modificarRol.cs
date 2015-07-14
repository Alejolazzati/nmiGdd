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
    public partial class modificarRol : Form
    {
        String rol;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
        
        public modificarRol(String unRol)
        {
            InitializeComponent();
            rol = unRol;
            textBox1.Text = rol;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;
            
            comando.CommandText = "select descripcion from NMI.Estado_rol ";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
/*
            comando.CommandText = "Select NMI.funcionalidadesPorRol(" + rol + ")";
            reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();
*/

        }

        private void modificarRol_Load(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
