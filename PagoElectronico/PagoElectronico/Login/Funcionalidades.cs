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
        int roli;
        public Funcionalidades(int rol)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            InitializeComponent();
            roli = rol;
            if (rol == 1)
            {
                comando.CommandText = "Select Id_cliente from Cliente,Usuario where Id_usuario=Cod_usuario and Useranme='" + Login.login.nombre + "'";
                System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
                label2.Text = "cliente";
                reader2.Read();
                Program.cliente = reader2.GetInt32(0);
                reader2.Dispose();
            }
            else label2.Text = "administrador";

            comando.CommandText = "Select * from funcionalidadesRol(" + rol + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();

        }

        private void Funcionalidades_Load(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
                   
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            String caseSwitch = comboBox1.SelectedItem.ToString();
            switch(caseSwitch)
            {
                case "ABM Rol":
                    PagoElectronico.ABM_Rol.formRol abmRol = new PagoElectronico.ABM_Rol.formRol();
                    abmRol.Show();
                    break;

                case "ABM usuario":
                    new PagoElectronico.ABM_de_Usuario.buscarUsuario().Show();
                    break;

                case "ABM cliente":

                    break;

                case "ABM cuenta":
                    if (roli == 1)
                    {
                        new PagoElectronico.ABM_Cuenta.buscarCuentaCliente().Show();
                    }
                    else
                    {
                        new PagoElectronico.ABM_Cuenta.buscarCuentaAdm().Show();
                    }
                    break;

                case "Facturacion":

                    break;

                case "Consultar saldo":
                    PagoElectronico.Consulta_Saldos.consultaSaldosCliente unaConsulta = new PagoElectronico.Consulta_Saldos.consultaSaldosCliente(roli);
                    unaConsulta.Show();
                    break;

                case "Listado estadistico":
                    new PagoElectronico.Listados.altaConsulta().Show();
                    break;

                case "sara":

                    break;

                case "asara":

                    break;

                case "adasd":

                    break;

                case "adads":

                    break;

                case "becGay":

                    break;

                default:
                    MessageBox.Show("Opcion invalida");
                    Program.end();
                    break;
                
            }
            this.Close();
            this.Hide();
            
        }

      
    }
}
