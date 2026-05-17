using BL.GSTP;
using BL.GSTP.ALD;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using BL.GSTP.BANGSETGET.QUAHAN;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.ALD.Hoso.Popup
{
    public partial class pTKQuaHan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSearch();
                Load_Data();
            }

        }

        private void Load_Data()
        {
            var lstData = DataExtensions.GetAll<TK_QUAHAN>().Where(x => x.TRANGTHAI != 99 && x.LOAIAN == 5 && x.TOAANID == Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + ""));
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            if (!string.IsNullOrWhiteSpace(dropNam.SelectedValue))
                lstData = lstData.Where(x => x.NAM.ToString() == dropNam.SelectedValue.Trim());
            if (!string.IsNullOrWhiteSpace(dropThang.SelectedValue))
                lstData = lstData.Where(x => x.THANG.ToString() == dropThang.SelectedValue.Trim());
            if (lstData != null && lstData.Count() > 0)
            {
                count_all = Convert.ToInt32(lstData.Count());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
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
            dgList.PageSize = page_size;
            dgList.DataSource = lstData;
            dgList.DataBind();
        }

        private void LoadSearch()
        {

            int year = DateTime.Now.Year;
            // Xóa danh sách cũ
            dropNam.Items.Clear();
            dropNam.Items.Add(new ListItem("---Chọn---", ""));
            for (int i = 2024; i <= year; i++)
            {
                dropNam.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
            dropNam.SelectedValue = "";
            //-----------------------------------
            dropThang.Items.Clear();
            dropThang.Items.Add(new ListItem("---Chọn---", ""));
            for (int i = 1; i <= 12; i++)
            {
                dropThang.Items.Add(new ListItem("Tháng " + i.ToString(), i.ToString()));
            }
            dropNam.SelectedValue = "";
        }


        //Thêm mới
        protected void cmdThemmoi_Click(object sender, EventArgs e)
        {
            string link = "/QLAN/ALD/Hoso/Popup/pThemTKQuaHan.aspx";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showOverlay();", true);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName == "Sua")
            {
                OpenPopupSua(e.CommandArgument.ToString());
            }
            else if (e.CommandName == "Xoa")
            {
                XoaThongKe(e.CommandArgument.ToString());
            }
        }
        private void OpenPopupSua(string id)
        {
            string link = "/QLAN/ALD/Hoso/Popup/pThemTKQuaHan.aspx?TKID=" + id;

            string script = $@"var Mleft = (screen.width / 2) - (1200 / 2);var Mtop = (screen.height / 2) - (750 / 2);window.open('{link}', '_blank',
                'height=750,width=1200,top=' + Mtop + ',left=' + Mleft +
                ',resizable=yes,toolbar=yes,scrollbars=1');
                showOverlay();";

            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true
            );
        }

        private void XoaThongKe(string id)
        {
            var tkQuaHan = DataExtensions.GetAllWithClause<TK_QUAHAN>($"ID = {Convert.ToDecimal(id)}").FirstOrDefault();
            if (tkQuaHan != null)
            {
                DataExtensions.Delete(tkQuaHan);
                var tkQuaHanCT = DataExtensions.GetAll<TK_QUAHAN_CHITIET>().Where(x => x.TKQUAHANID == tkQuaHan.ID).ToList();
                foreach (var item in tkQuaHanCT)
                {
                    DataExtensions.Delete(item);
                }
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertMessage", "alert('Xóa thành công!');", true);
            Load_Data();
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                e.Item.Cells[0].Text = (e.Item.ItemIndex + 1).ToString();
            }
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            dropNam.SelectedValue = "";
            dropThang.SelectedValue = "";
            Load_Data();
        }

        protected void cmdLoadTKQuaHan_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thêm  mới thành công!');", true);
            Load_Data();
        }

        protected void cmdLoadTKQuaHan_GuiDL_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi dữ liệu thành công!');", true);
            Load_Data();
        }

        protected void cmdLoadTKQuaHan_Sua_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Sửa thành công!');", true);
            Load_Data();
        }

        #region phân trang
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion phân trang
    }
}