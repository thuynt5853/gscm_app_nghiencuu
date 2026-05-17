using BL.GSTP.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP
{
    public partial class DanhsachAnHuy : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadData();
                    if (Request["tt"] + "" == "1")
                    {
                        lbthongbao.Text = "Lưu đánh giá thành công!";
                    }
                }
            }
            catch (Exception ex)
            {
                pndata.Visible = false;
                lbthongbao.Text = ex.Message;
            }
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            GSTP_BL gSTP_BL = new GSTP_BL();
            decimal DonViLoGinID = string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "") ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable dtTable = gSTP_BL.GetDanhSachAnHuy(DonViLoGinID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                int Total = dtTable.Rows.Count, pageSize = Convert.ToInt32(hddPageSize.Value);
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                dgList.PageSize = pageSize;
                dgList.DataSource = dtTable;
                dgList.DataBind();
                GroupColumnData(dgList, Convert.ToInt32(0));
                pndata.Visible = true;
            }
            else
            {
                lbthongbao.Text = "Không có dữ liệu!";
                pndata.Visible = false;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadData();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadData();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadData();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            LoadData();
        }
        #endregion

        private void GroupColumnData(DataGrid dataGrid, int columnIndex)
        {
            int countItemInGroupSTT = 0, countItemInGroupVuAn = 0, countItemInGroupToaAn = 0, rowIndex = 0, FirstRowIndexOfGroupVuAN = 0, FirstRowIndexOfGroupToaAn = 0;
            foreach (DataGridItem item in dataGrid.Items)
            {
                if (item.ItemIndex > 0)
                {
                    rowIndex = item.ItemIndex;
                    string strCurr = ((HiddenField)item.FindControl("hddStt")).Value;
                    string strBefore = ((HiddenField)dataGrid.Items[rowIndex - 1].FindControl("hddStt")).Value;

                    string hddVuAnIDCur = ((HiddenField)item.FindControl("hddVuAnID")).Value;
                    string hddVuAnIDBefore = ((HiddenField)dataGrid.Items[rowIndex - 1].FindControl("hddVuAnID")).Value;
                    string hddToaAnIDCur = ((HiddenField)item.FindControl("hddToaAnID")).Value;
                    string hddToaAnIDBefore = ((HiddenField)dataGrid.Items[rowIndex - 1].FindControl("hddToaAnID")).Value;

                    if (strCurr == strBefore)
                    {
                        if (FirstRowIndexOfGroupVuAN == 0)
                        { FirstRowIndexOfGroupVuAN = rowIndex; }
                        countItemInGroupSTT++;
                        dataGrid.Items[FirstRowIndexOfGroupVuAN - 1].Cells[0].RowSpan = countItemInGroupSTT + 1;
                        item.Cells[0].Visible = false;
                    }
                    else
                    {
                        FirstRowIndexOfGroupVuAN = countItemInGroupSTT = countItemInGroupVuAn = countItemInGroupToaAn = 0;
                        item.Cells[0].Visible = true;
                    }

                    if (hddVuAnIDCur == hddVuAnIDBefore)
                    {
                        if (FirstRowIndexOfGroupVuAN == 0)
                        { FirstRowIndexOfGroupVuAN = rowIndex; }
                        countItemInGroupVuAn++;
                        dataGrid.Items[FirstRowIndexOfGroupVuAN - 1].Cells[1].RowSpan = countItemInGroupVuAn + 1;
                        item.Cells[1].Visible = false;
                    }
                    else
                    {
                        FirstRowIndexOfGroupVuAN = countItemInGroupVuAn = 0;
                        item.Cells[1].Visible = true;
                    }

                    if (hddToaAnIDCur == hddToaAnIDBefore)
                    {
                        if (FirstRowIndexOfGroupToaAn == 0)
                        { FirstRowIndexOfGroupToaAn = rowIndex; }
                        countItemInGroupToaAn++;
                        dataGrid.Items[FirstRowIndexOfGroupToaAn - 1].Cells[2].RowSpan = countItemInGroupToaAn + 1;
                        item.Cells[2].Visible = false;
                    }
                    else
                    {
                        FirstRowIndexOfGroupToaAn = countItemInGroupToaAn = 0;
                        item.Cells[2].Visible = true;
                    }

                    //if (strCurr == strBefore)
                    //{
                    //    if (FirstRowIndexOfGroup == 0)
                    //    { FirstRowIndexOfGroup = rowIndex; }
                    //    countItemInGroup++;
                    //    dataGrid.Items[FirstRowIndexOfGroup - 1].Cells[columnIndex].RowSpan = countItemInGroup + 1;
                    //    item.Cells[columnIndex].Visible = false;

                    //    dataGrid.Items[FirstRowIndexOfGroup - 1].Cells[columnIndex + 1].RowSpan = countItemInGroup + 1;
                    //    item.Cells[columnIndex + 1].Visible = false;

                    //    dataGrid.Items[FirstRowIndexOfGroup - 1].Cells[columnIndex + 2].RowSpan = countItemInGroup + 1;
                    //    item.Cells[columnIndex + 2].Visible = false;
                    //}
                    //else
                    //{
                    //    FirstRowIndexOfGroup = countItemInGroup = 0;
                    //    item.Cells[columnIndex].Visible = true;
                    //    item.Cells[columnIndex + 1].Visible = true;
                    //    item.Cells[columnIndex + 2].Visible = true;
                    //}
                }

            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string StrPara = "", vuAnID = "", TPID = "", LoaiAn = "", ToaAnID = "", MaVaiTro = "";
            StrPara = e.CommandArgument.ToString();
            if (StrPara.Contains(";#"))
            {
                string[] arr = StrPara.Split(';');
                vuAnID = arr[0] + "";
                TPID = arr[1].Replace("#", "") + "";
                LoaiAn = arr[2].Replace("#", "") + "";
                ToaAnID = arr[3].Replace("#", "") + "";
                MaVaiTro = arr[4].Replace("#", "") + "";
            }
            switch (e.CommandName)
            {
                case "TPDanhGia":
                    StrPara = "Capnhatdanhgia.aspx?vua=" + vuAnID + "&thp=" + TPID + "&loa=" + LoaiAn + "&dga=1" + "&toa=" + ToaAnID + "&vtr=" + MaVaiTro;
                    Response.Redirect(StrPara);
                    break;
                case "HDDanhGia":
                    StrPara = "Capnhatdanhgia.aspx?vua=" + vuAnID + "&thp=" + TPID + "&loa=" + LoaiAn + "&dga=0" + "&toa=" + ToaAnID + "&vtr=" + MaVaiTro;
                    Response.Redirect(StrPara);
                    break;
            }
        }
    }
}