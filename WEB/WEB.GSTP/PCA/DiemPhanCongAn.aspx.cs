using BL.GSTP.PCTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.PCA
{
    public partial class DiemPhanCongAn : System.Web.UI.Page
    {
        PCANN_BL pca = new PCANN_BL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable check_pcdon = pca.PCANN_CHECK_TOA_PCDON(toa_an_id);
                if (check_pcdon.Rows.Count > 0)
                {
                    ddlgiaidoan.Enabled = false;
                }
                else
                {
                    ddlgiaidoan.Enabled = true;
                }
                Load_Data();
            }
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
           
            //decimal toa_an_id = 27;
            decimal giai_doan = Convert.ToInt32(ddlgiaidoan.SelectedValue);
            decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            string ten_vuan = Txtvuan.Text.Trim();
            string ten_thamphan = Textthamphan.Text.Trim();
            string tu_ngay = txtTuNgay.Text.Trim();
            string den_ngay = txtDenNgay.Text.Trim();

            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            
            var result = pca.PCANN_DS_DIEMDAPC(giai_doan, toa_an_id, ten_vuan, ten_thamphan, tu_ngay, den_ngay, pageindex, page_size);
            DataTable tbl = result.Tables[0];
            DataTable tbl_diem = result.Tables[1];
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int count_all = Convert.ToInt32(tbl.Rows[0]["count_all"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }


            StringBuilder html = new StringBuilder();
            //Table start.
            html.Append("<table border = '1' class='table2'>");
            //Building the Header row.
            html.Append("<tr class='header'>");
            html.Append("<td style = 'width:5%;'>STT</td>");
            html.Append("<td style = 'width:50%;'>Tên vụ án</td>");
            html.Append("<td style = 'width:15%;'>Ngày phân công</td>");
            html.Append("<td style = 'width:20%;'>Thẩm phán</td>");
            html.Append("<td style = 'width:10%;'>Tổng điểm</td>");
            html.Append("</tr>");
            //Building the Data rows.
            foreach (DataRow row in tbl.Rows)
            {
                html.Append("<tr>");
                html.Append("<td rowspan='" + (Convert.ToInt32(row["SO_TP"]) + 1) + "'>");
                html.Append(row["RNUM"]);
                html.Append("</td>");

                html.Append("<td rowspan='" + (Convert.ToInt32(row["SO_TP"]) + 1) + "' align='left'>");
                html.Append(row["TEN_VU_AN"]);
                html.Append("</td>");
                html.Append("</tr>");
                var loai_an = row["LOAI_AN"].ToString();
                var id_vuan = row["ID_VU_AN"].ToString();
                foreach (DataRow rowdiem in tbl_diem.Rows)
                {
                    var loai_andiem = rowdiem["LOAI_AN"].ToString();
                    var id_vuandiem = rowdiem["ID_VU_AN"].ToString();
                    if (id_vuan == id_vuandiem && loai_an == loai_andiem)
                    {
                        if (rowdiem["ID_CAN_BO"].ToString() == rowdiem["ID_THAM_PHAN_CT"].ToString())
                        {
                            html.Append("<tr class='header chan'>");

                            html.Append("<td>");
                            html.Append(rowdiem["NGAY_PHAN_CONG"]);
                            html.Append("</td>");

                            html.Append("<td align='left'>");
                            html.Append(rowdiem["HOTEN"]);
                            html.Append("</td>");

                            html.Append("<td align='right'>");
                            html.Append(rowdiem["TONG_DIEM"]);
                            html.Append("</td>");

                            html.Append("</tr>");
                        }
                        else
                        {
                            html.Append("<tr class='chan'>");

                            html.Append("<td>");
                            html.Append(rowdiem["NGAY_PHAN_CONG"]);
                            html.Append("</td>");

                            html.Append("<td  align='left'>");
                            html.Append(rowdiem["HOTEN"]);
                            html.Append("</td>");

                            html.Append("<td align='right'>");
                            html.Append(rowdiem["TONG_DIEM"]);
                            html.Append("</td>");

                            html.Append("</tr>");
                        }

                    }

                }
            }
            //Table end.
            html.Append("</table>");
            string strText = html.ToString();
            ////Append the HTML string to Placeholder.
            placeholder.Controls.Add(new Literal { Text = html.ToString() });

            //dgList.DataSource = tbl_diem;
            //dgList.DataBind();
            
        }
        protected void ddlgiaidoan_SelectedIndexChanged(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            // dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion
    }
}