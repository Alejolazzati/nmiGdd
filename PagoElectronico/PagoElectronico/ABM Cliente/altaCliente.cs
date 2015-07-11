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
        DateTime fechaElegida;
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
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();

            while (reader2.Read())
            {
                comboBox1.Items.Add(reader2.GetSqlString(0));
            }
            this.Show();

            reader2.Dispose();
           


        }


        private void button6_Click(object sender, EventArgs e)
        {
            new Calendario(this).Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            //ver las validaciones vs defaults y not nulls en la base
            nombre = textBox11.Text;
            apellido = textBox1.Text;
            numeroDoc = maskedTextBox1.Text;
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            if (textBox7.TextLength > 0) { piso = textBox7.Text; }
            if (textBox4.TextLength > 0) { depto = textBox4.Text; }
            tipoDocumento = comboBox2.SelectedItem.ToString();
            Nacionalidad = comboBox1.SelectedItem.ToString();

            MessageBox.Show(fechaElegida+nombre + apellido + numeroDoc + mail + domicilio + piso + depto + tipoDocumento + Nacionalidad);

          //  System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
         //   comando.CommandText = "execute dbo.transferir " + cuenta + "," + textBox3.Text + "," + textBox2.Text + ",'" + Program.fecha + "'";
           
           // comando.ExecuteNonQuery();
               
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox13.Text = unaFecha.ToShortDateString();
        }

        private void altaCliente_Load(object sender, EventArgs e)
        {
            maskedTextBox1.Mask = "0999999999999999999999";
        }

        


       

    }
}
