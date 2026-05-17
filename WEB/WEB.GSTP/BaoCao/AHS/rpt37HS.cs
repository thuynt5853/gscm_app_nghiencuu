using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHS
{
    public partial class rpt37HS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt37HS()
        {
            InitializeComponent();
        }

        private void SubBand_HDXX_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prm_HDXX"].Value + "" == "")
            {
                SubBand_HDXX.Visible = false;
            }
            else
            {
                SubBand_HDXX.Visible = true;
            }
        }

        private void SubBand_HTND_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prm_HTND"].Value + "" == "")
            {
                SubBand_HTND.Visible = false;
            }
            else
            {
                SubBand_HTND.Visible = true;
            }
        }
    }
}
