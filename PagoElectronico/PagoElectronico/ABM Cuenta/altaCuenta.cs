using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cuenta
{

    public partial class altaCuenta : Form
    {
        String numCuenta;
        System.DateTime fechaElegida;
        String pais;
        String moneda;
        String categoria;

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
           
        public altaCuenta()
        {
            InitializeComponent();

            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox3.DropDownStyle = ComboBoxStyle.DropDownList;
            //cargar paises
            comando.CommandText = "Select descripcion from NMI.pais";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox3.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();
            
            //cargar moneda


            comando.CommandText = "Select descripcion from NMI.MONEDA";
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
            while (reader2.Read())
            {
                comboBox1.Items.Add(reader2.GetSqlString(0));

            }
            this.Show();
            reader2.Dispose();


            // cargar categoria


            comando.CommandText = "Select descripcion from NMI.categoria";
            System.Data.SqlClient.SqlDataReader reader3 = comando.ExecuteReader();
            while (reader3.Read())
            {
                comboBox2.Items.Add(reader3.GetSqlString(0));

            }
            this.Show();
            reader3.Dispose();


        }

        
        private void button2_Click(object sender, EventArgs e)
        {
            //al confirmar

            //lecturas de los comboBox
            try
            {
                pais = comboBox3.SelectedItem.ToString();
                categoria = comboBox2.SelectedItem.ToString();
                moneda = comboBox1.SelectedItem.ToString();
            }
            catch (NullReferenceException er) { MessageBox.Show("Complete los campos"); return; }

            comando.CommandText = "exec NMI.altaCuenta "+Program.cliente+", '"+pais+"','"+moneda+"','"+categoria+"'"; 
                  
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Operacion exitosa");
                new Login.Funcionalidades().Show();
                this.Close();
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
                
            }
                    
         


        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            new Login.Funcionalidades().Show();
            this.Close();
        }                        

    }
}
