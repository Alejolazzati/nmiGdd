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
    public partial class modificarRol : Form
    {
        String rol;
        public modificarRol(String unRol)
        {
            InitializeComponent();
            rol = unRol;
            textBox1.Text = rol;
        }

        private void modificarRol_Load(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
