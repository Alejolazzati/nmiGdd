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
   
    public partial class altaTarjeta : Form
    {
        String numTarjeta;
        String fechaEmision;
        String fechaVto;
        String emisor;
        String codSeguridad;
        public altaTarjeta()
        {
            InitializeComponent();
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            textBox2.ReadOnly = true;
            textBox3.ReadOnly = true;
            maskedTextBox1.Mask = "0000-0000-0000-0000";
            maskedTextBox2.Mask = "000";

        }

        private void button1_Click(object sender, EventArgs e)
        {
            new calendar(2, this).Show();
        }

        private void altaTarjeta_Load(object sender, EventArgs e)
        {
            //cargar emisores de tarjeta
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select descripcion from nmi.tarjeta_emisor";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlValue(0).ToString());
            }
            this.Show();
            reader.Dispose();


        }

        public void recibirFecha(int textBoxLlamo,DateTime unaFecha){
            if (textBoxLlamo == 2)
            {
                fechaEmision = unaFecha.ToShortDateString();
                textBox2.Text = unaFecha.ToShortDateString();
            }
            else
            {
                fechaVto = unaFecha.ToShortDateString();
                textBox3.Text = unaFecha.ToShortDateString();
            }


        }

        private void button4_Click(object sender, EventArgs e)
        {
            //VOLVER A FUNC
            new Login.Funcionalidades().Show();
            this.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            new calendar(3, this).Show();
        }

        private void button3_Click(object sender, EventArgs e)
        { //confirmar
            int i =0;
            try
            {
                emisor = comboBox1.SelectedItem.ToString();
            }
            catch (NullReferenceException er) { MessageBox.Show("Elija un emisor"); i++; }
            if (textBox2.Text.Length == 0) { MessageBox.Show("Complete la fecha de emision");i++; }
            if (textBox3.Text.Length == 0) { MessageBox.Show("Complete la fecha de vencimiento"); i++; }
            if (!maskedTextBox1.MaskCompleted) { MessageBox.Show("ingrese correctamente numero de tarjeta"); i++; }
            if (!maskedTextBox2.MaskCompleted) { MessageBox.Show("ingrese correctamente el codigo de seguridad"); i++; }
            if (i > 0) { return; }

            if (Convert.ToDateTime(textBox2.Text) < Convert.ToDateTime(Program.fecha)) { MessageBox.Show("La fecha de vencimiento no puede ser anterior que la actual"); return; }
            if (Convert.ToDateTime(textBox3.Text) < Convert.ToDateTime(textBox2.Text)) { MessageBox.Show("La fecha de vencimiento no puede ser anterior que la fecha de emision"); return; }
              
            
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "exec nmi.asociarTarjeta '"+ maskedTextBox1.Text +"','"+emisor+"','"+fechaEmision+"','"+fechaVto+"','"+maskedTextBox2.Text+"',"+ Program.cliente;
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Operacion exitosa");
                new Login.Funcionalidades().Show();
                this.Close();
            }
            catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }

    
        }
            

    }
}
