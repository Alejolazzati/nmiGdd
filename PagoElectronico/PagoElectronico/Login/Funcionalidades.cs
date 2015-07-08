using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Login
{
    public partial class Funcionalidades : Form
    {
        private int rolUsuario;
        public Funcionalidades(int rol)
        {
            InitializeComponent();
            rolUsuario = rol;
        }

        private void Funcionalidades_Load(object sender, EventArgs e)
        {

        }
    }
}
