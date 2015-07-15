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

            comando.CommandText = "Select * from NMI.funcionalidadesPorRol('" + rol + "')";
            reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

            comando.CommandText = "Select NMI.Funcionalidad.Descripcion from NMI.Funcionalidad  left join NMI.funcionalidadesPorRol('" + rol + "') as t2  on NMI.Funcionalidad.Descripcion=t2.Descripcion where t2.Descripcion is null";
            reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

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

        private void button2_Click(object sender, EventArgs e)
        {
            listBox2.Items.Add(listBox1.SelectedItem);
            listBox1.Items.Remove(listBox1.SelectedItem);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            listBox1.Items.Add(listBox2.SelectedItem);
            listBox2.Items.Remove(listBox2.SelectedItem);
        }
    }
}
