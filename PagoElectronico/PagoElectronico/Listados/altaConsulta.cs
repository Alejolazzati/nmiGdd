using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Listados
{
    public partial class altaConsulta : Form
    {
        int trimestre; // 1 = primer 2= 2do 3= 3ro
        public altaConsulta()
        {
            InitializeComponent();
        }

        private void altaConsulta_Load(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (textBox1.Text.Length==0){ //HAY QUE VALIDAR TMB CONTRA LA FECHA DEL CONFIG
                MessageBox.Show("Ingrese un año valido");
            }
            else {
                comboBox1.Items.Add("Primer trimestre");
                comboBox1.Items.Add("Segundo trimestre");
                comboBox1.Items.Add("Tercer trimestre");
            }
        

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {

        }
    }
}
