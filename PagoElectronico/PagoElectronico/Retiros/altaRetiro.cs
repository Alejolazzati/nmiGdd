using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Retiros
{
    public partial class altaRetiro : Form
    {
        public altaRetiro()
        {
            InitializeComponent();
        }

        private void altaRetiro_Load(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select Descripcion from NMI.Moneda";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));
            }
            
            reader.Dispose();
            comando.CommandText = "Select Nombre_banco from NMI.Bancos";
            reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }

            reader.Dispose();
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (comboBox1.SelectedItem == null)
            {
                MessageBox.Show("debe seleccionar moneda");
                return;
            }
            if (comboBox2.SelectedItem == null)
            {
                MessageBox.Show("debe seleccionar Banco");
                return;
            }

            if (textBox1.Text.Length==0)
            {
                MessageBox.Show("debe Ingresar importe");
                return;
            }

            if (textBox2.Text.Length == 0)
            {
                MessageBox.Show("debe Ingresar Num_Cheque");
                return;
            }
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "execute NMI.asentarRetiro "+Program.cuenta.ToString()+","+textBox2.Text+","+textBox1.Text+",'"+comboBox2.SelectedItem.ToString()+"',"+Program.cliente.ToString()+",'"+comboBox1.SelectedItem.ToString()+"'";



            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("retiro efectuado");
             }
            catch (System.Data.SqlClient.SqlException ex)
            {
                MessageBox.Show("Sql exception: " + ex.Message);
            }
            new PagoElectronico.Login.Funcionalidades().Show();
            this.Close();
        
        }
    }
}
