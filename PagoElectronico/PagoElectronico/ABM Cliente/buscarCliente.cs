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
    public partial class buscarCliente : Form
    {
        string nombre;
        string apellido;
        string numeroDoc;
        string mail;

        public buscarCliente()
        {
            InitializeComponent();
        }

        private void button8_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Cliente.altaCliente().Show();
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            new buscarCliente().Show();
            this.Close();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void maskedTextBox1_MaskInputRejected(object sender, MaskInputRejectedEventArgs e)
        {

        }

       private void buscarCliente_Load(object sender, EventArgs e)
        {
            maskedTextBox1.Mask = "##############################";
       }
    }
}
