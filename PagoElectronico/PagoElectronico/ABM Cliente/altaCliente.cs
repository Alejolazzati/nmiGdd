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
        String userName;
        String contraseña;
        String preguntaSecreta;
        String respuestaSecreta;
        int Rol;
        string numero;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public altaCliente()
           {
            InitializeComponent();
            comando.CommandText = "Select * from NMI.documentosDisponibles()";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           
            
            //CARGAR NACIONALIDADES

            comando.CommandText = "Select * from NMI.getNacionalidades()";
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
            while (reader2.Read())
            {
                comboBox1.Items.Add(reader2.GetSqlString(0));
            }
            this.Show();

            reader2.Dispose();
           
            //Cargar roles

           

           
           


        }


        private void button6_Click(object sender, EventArgs e)
        {
            new Calendario(this).Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {


            nombre = textBox5.Text;

            apellido = textBox1.Text;
            numeroDoc = textBox10.Text;
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            piso = textBox2.Text;
            depto = textBox4.Text;
            tipoDocumento = comboBox2.SelectedItem.ToString();
            Nacionalidad = comboBox1.SelectedItem.ToString();
            userName = textBox6.Text;
            contraseña = Encriptar.SHA256(textBox7.Text);
            preguntaSecreta = textBox8.Text;
            respuestaSecreta = textBox11.Text;
            numero = textBox12.Text;
System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            try
            {
                
                comando.CommandText = "begin transaction exec NMI.ingresarUsuario '" + userName + "','" + Encriptar.SHA256(contraseña) + "','" + preguntaSecreta + "','" + Encriptar.SHA256(respuestaSecreta) + "'," + 1.ToString()+" exec NMI.ingresarCliente '" + userName + "','" + nombre + "','" + apellido + "','" + tipoDocumento + "'," + numeroDoc + ",'" + mail + "','" + Nacionalidad + "','" + domicilio + "'," + numero + "," + piso + ",'" + depto + "','" + fechaElegida + "'"+" commit";



                comando.ExecuteNonQuery(); new PagoElectronico.Login.Funcionalidades().Show();
                this.Close();
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                MessageBox.Show(ex.Message);

            }
            catch { MessageBox.Show("Ingrese correctamente los valores"); }
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox13.Text = unaFecha.ToShortDateString();
        }

        private void altaCliente_Load(object sender, EventArgs e)
        {

        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox7_TextChanged(object sender, EventArgs e)
        {

        }

        

        

    }
}
