using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cliente
{
    public partial class altaCliente : Form
    {

        string nombre;
        string apellido;
        Date fechaElegida;
        string numeroDoc;
        String mail;
        string domicilio;
        string piso;
        string depto;
        String tipoDocumento;
        String Nacionalidad;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public altaCliente()
           {
            InitializeComponent();
            comando.CommandText = "Select * from documentosDisponibles()";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           
            
            //CARGAR NACIONALIDADES

            comando.CommandText = "Select * from getNacionalidades()";
            
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           


        }


        private void button6_Click(object sender, EventArgs e)
        {
            new Calendario(this).Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            nombre = textBox11.Text;
            apellido = textBox1.Text;
            numeroDoc = textBox10.Text;
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            piso = textBox7.Text;
            depto = textBox4.Text;
            tipoDocumento = comboBox2.SelectedItem.ToString();
            Nacionalidad = comboBox1.SelectedItem.ToString();
            


          //  System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
         //   comando.CommandText = "execute dbo.transferir " + cuenta + "," + textBox3.Text + "," + textBox2.Text + ",'" + Program.fecha + "'";
           
            comando.ExecuteNonQuery();
               
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox13.Text = unaFecha.ToShortDateString();
        }

    }
}
