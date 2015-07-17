using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Consulta_Saldos
{
    public partial class consultaSaldosCliente : Form
    {
        
        public consultaSaldosCliente()
        {
            
            InitializeComponent();
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from NMI.cuentasPorCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlValue(0));
                this.Show();
              

            }
            reader.Dispose();
           }

        private void consultaSaldosCliente_Load(object sender, EventArgs e)
        {
           
            }

        private void button7_Click(object sender, EventArgs e)
        {
            if (comboBox1.SelectedIndex == -1) { MessageBox.Show("Seleccionar una cuenta"); return; }
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select NMI.saldoCuenta(" + comboBox1.SelectedItem + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            MessageBox.Show(reader.GetSqlValue(0).ToString());
            reader.Dispose();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            PagoElectronico.Login.Funcionalidades funci = new PagoElectronico.Login.Funcionalidades();
            funci.Show();
            this.Close();
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (comboBox1.SelectedIndex == -1) { MessageBox.Show("Seleccionar una cuenta"); return; }
            PagoElectronico.Consulta_Saldos.consultaSaldos unaConsul = new PagoElectronico.Consulta_Saldos.consultaSaldos(comboBox1.SelectedItem.ToString());
            unaConsul.Show();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
            
        }
    }

