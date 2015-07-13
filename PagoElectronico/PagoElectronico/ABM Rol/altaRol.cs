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
    public partial class formRol : Form
    {
        public formRol()
        {
            InitializeComponent();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select NMI.Estado_rol.Descripcion from NMI.Estado_rol";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();

            comando.CommandText = "select NMI.Funcionalidad.Descripcion from NMI.Funcionalidad";
            reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();




        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void groupBox2_Enter(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {   

            listBox1.Items.Add(listBox2.SelectedItem);
            listBox2.Items.Remove(listBox2.SelectedItem);
            
        }

        private void button2_Click(object sender, EventArgs e)
        {   
            listBox2.Items.Add(listBox1.SelectedItem);
            listBox1.Items.Remove(listBox1.SelectedItem);
           
        }
    }
}
