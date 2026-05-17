using BL.GSTP;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.QuyetDinh
{
    public partial class Lydo : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropQD();
                    decimal QDID = Convert.ToDecimal(DropQD.SelectedValue);
                    FillThuTu(GetListQuyetDinhByLoaiQD(QDID).Count + 1);
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropQD()
        {
            DropQD.Items.Clear();
            if (Request["qd"] != null)
            {
                decimal qdID = Convert.ToDecimal(Request["qd"].ToString());
                DM_QD_QUYETDINH qd = dt.DM_QD_QUYETDINH.Where(x => x.ID == qdID).FirstOrDefault<DM_QD_QUYETDINH>();
                if (qd != null)
                {
                    DropQD.Items.Add(new ListItem(qd.TEN, qdID.ToString()));
                }
                else
                {
                    DropQD.Items.Add(new ListItem("Chọn", "0"));
                }
            }
            else
            {
                DropQD.Items.Add(new ListItem("Chọn", "0"));
            }
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            string TextKey = txtTimKiem.Text.Trim();
            decimal QdID = Convert.ToDecimal(DropQD.SelectedValue);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value), pageSize = Convert.ToInt32(hddPageSize.Value);
            DM_QD_QUYETDINH_BL oBL = new DM_QD_QUYETDINH_BL();
            DataTable lst = oBL.DM_QD_QUYETDINH_LYDO_SEARCH(QdID, TextKey, pageIndex, pageSize);
            if (lst != null && lst.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(lst.Rows[0]["Total"]);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                pnlDataTable.Visible = cmdThutu.Visible = true;
            }
            else
            {
                pnlDataTable.Visible = cmdThutu.Visible = false;
            }
            dgList.DataSource = lst;
            dgList.DataBind();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
                        LoadEdit(curr_id);
                        hddLyDoID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        Xoa(curr_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    DropDownList dropThuTuChildren = (DropDownList)e.Item.FindControl("DropThuTuChildren");
                    decimal QdID = Convert.ToDecimal(rv["QDID"].ToString()), countItem = 0, ThuTu = 0;
                    List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == QdID).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        countItem = lst.Count;
                        for (int i = 1; i <= countItem; i++)
                        {
                            dropThuTuChildren.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                    }
                    ThuTu = Convert.ToDecimal(rv["THUTU"].ToString());
                    if (countItem <= ThuTu)
                    {
                        dropThuTuChildren.SelectedValue = countItem.ToString();
                    }
                    else
                    {
                        dropThuTuChildren.SelectedValue = ThuTu.ToString();
                    }
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        private void LoadEdit(decimal id)
        {
            lbthongbao.Text = "";
            DM_QD_QUYETDINH_LYDO qd = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == id).FirstOrDefault<DM_QD_QUYETDINH_LYDO>();
            if (qd != null)
            {
                DropQD.SelectedValue = qd.QDID.ToString();
                txtMa.Text = qd.MA;
                txtTen.Text = qd.TEN;
                DropThuTu.SelectedValue = qd.THUTU.ToString();
                chkHieuluc.Checked = Convert.ToBoolean(qd.HIEULUC);
            }
        }
        private void Xoa(decimal id)
        {
            DM_QD_QUYETDINH_LYDO qd = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == id).FirstOrDefault<DM_QD_QUYETDINH_LYDO>();
            if (qd != null)
            {
                dt.DM_QD_QUYETDINH_LYDO.Remove(qd);
                dt.SaveChanges();
            }
            ResetControl();
            hddPageIndex.Value = "1";
            LoadData();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void DropQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal QdID = Convert.ToDecimal(DropQD.SelectedValue);
                FillThuTu(GetListQuyetDinhByLoaiQD(QdID).Count + 1);
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            if (!ValidateData())
            {
                return;
            }
            decimal LyDoID = Convert.ToDecimal(hddLyDoID.Value);
            bool isNew = false;
            DM_QD_QUYETDINH_LYDO lyDo = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == LyDoID).FirstOrDefault<DM_QD_QUYETDINH_LYDO>();
            if (lyDo == null)
            {
                isNew = true;
                lyDo = new DM_QD_QUYETDINH_LYDO();
                lyDo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                lyDo.NGAYTAO = DateTime.Now;
            }
            else
            {
                lyDo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                lyDo.NGAYSUA = DateTime.Now;
            }
            lyDo.QDID = Convert.ToDecimal(DropQD.SelectedValue);
            lyDo.MA = txtMa.Text.Trim();
            lyDo.TEN = txtTen.Text.Trim();
            lyDo.THUTU = Convert.ToDecimal(DropThuTu.SelectedValue);
            lyDo.HIEULUC = chkHieuluc.Checked ? 1 : 0;
            if (isNew)
            {
                dt.DM_QD_QUYETDINH_LYDO.Add(lyDo);
            }
            dt.SaveChanges();
            ResetControl();
            hddPageIndex.Value = "1";
            LoadData();
            lbthongbao.Text = "Lưu thành công!";
        }
        protected void cmdXoa_Click(object sender, EventArgs e)
        {
            try
            {
                decimal LyDoID = Convert.ToDecimal(hddLyDoID.Value);
                Xoa(LyDoID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            try
            {
                ResetControl();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void ResetControl()
        {
            txtMa.Text = txtTen.Text = lbthongbao.Text = "";
            decimal QdID = Convert.ToDecimal(DropQD.SelectedValue);
            FillThuTu(GetListQuyetDinhByLoaiQD(QdID).Count + 1);
            chkHieuluc.Checked = false;
            hddLyDoID.Value = "0";
        }
        private void FillThuTu(int Count)
        {
            DropThuTu.Items.Clear();
            if (Count > 0)
            {
                for (int i = 1; i <= Count; i++)
                {
                    DropThuTu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                DropThuTu.SelectedIndex = Count - 1;
            }
            else
            {
                DropThuTu.Items.Add(new ListItem("1", "1"));
            }
        }
        private List<DM_QD_QUYETDINH_LYDO> GetListQuyetDinhByLoaiQD(decimal qDID)
        {
            return dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == qDID).ToList();
        }
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            int ColIDIndex = 0;
            decimal LyDoID = 0;
            DM_QD_QUYETDINH_LYDO LyDo = new DM_QD_QUYETDINH_LYDO();
            foreach (DataGridItem oItem in dgList.Items)
            {

                LyDoID = Convert.ToDecimal(oItem.Cells[ColIDIndex].Text);
                LyDo = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == LyDoID).FirstOrDefault<DM_QD_QUYETDINH_LYDO>();
                DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                LyDo.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                LyDo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                LyDo.NGAYSUA = DateTime.Now;
                dt.SaveChanges();
            }
            hddPageIndex.Value = "1";
            LoadData();
        }
        private bool ValidateData()
        {
            if (DropQD.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn quyết định. Hãy chọn lại!";
                return false;
            }
            int lengthMa = txtMa.Text.Trim().Length;
            if (lengthMa == 0 || lengthMa > 20)
            {
                lbthongbao.Text = "Mã lý do không được trống hoặc quá 20 ký tự. Hãy nhập lại!";
                txtMa.Focus();
                return false;
            }
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen == 0 || lengthTen > 500)
            {
                lbthongbao.Text = "Tên lý do không được trống hoặc quá 500 ký tự. Hãy nhập lại!";
                txtTen.Focus();
                return false;
            }
            return true;
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Quyetdinh.aspx?loaiqd=" + Request["loaiqd"] + "&pg=" + Request["pg"]);
        }
    }
}