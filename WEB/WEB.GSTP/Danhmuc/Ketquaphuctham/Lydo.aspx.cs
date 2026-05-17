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

namespace WEB.GSTP.Danhmuc.Ketquaphuctham
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
                    LoadDropKQ();
                    decimal KqID = Convert.ToDecimal(DropKQ.SelectedValue);
                    FillThuTu(GetListLyDoByKetQua(KqID).Count + 1);
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropKQ()
        {
            DropKQ.Items.Clear();
            if (Request["kq"] != null)
            {
                decimal kqID = Convert.ToDecimal(Request["kq"].ToString());
                DM_KETQUA_PHUCTHAM qd = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ID == kqID).FirstOrDefault<DM_KETQUA_PHUCTHAM>();
                if (qd != null)
                {
                    DropKQ.Items.Add(new ListItem(qd.TEN, kqID.ToString()));
                }
                else
                {
                    DropKQ.Items.Add(new ListItem("Chọn", "0"));
                }
            }
            else
            {
                DropKQ.Items.Add(new ListItem("Chọn", "0"));
            }
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            string TextKey = txtTimKiem.Text.Trim();
            decimal kqID = Convert.ToDecimal(DropKQ.SelectedValue);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value), pageSize = Convert.ToInt32(hddPageSize.Value);
            DM_KETQUA_PHUCTHAM_LYDO_BL oBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable lst = oBL.DM_KETQUA_PT_LYDO_SEARCH(kqID, TextKey, pageIndex, pageSize);
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
                    decimal kqID = Convert.ToDecimal(rv["KETQUAID"].ToString()), countItem = 0, ThuTu = 0;
                    List<DM_KETQUA_PHUCTHAM_LYDO> lst = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.KETQUAID == kqID).ToList();
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
            DM_KETQUA_PHUCTHAM_LYDO lyDo = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.ID == id).FirstOrDefault<DM_KETQUA_PHUCTHAM_LYDO>();
            if (lyDo != null)
            {
                DropKQ.SelectedValue = lyDo.KETQUAID.ToString();
                txtMa.Text = lyDo.MA;
                txtTen.Text = lyDo.TEN;
                txtGhiChu.Text = lyDo.GHICHU;
                DropThuTu.SelectedValue = lyDo.THUTU.ToString();
            }
        }
        private void Xoa(decimal id)
        {
            DM_KETQUA_PHUCTHAM_LYDO lyDo = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.ID == id).FirstOrDefault<DM_KETQUA_PHUCTHAM_LYDO>();
            if (lyDo != null)
            {
                dt.DM_KETQUA_PHUCTHAM_LYDO.Remove(lyDo);
                dt.SaveChanges();
            }
            ResetControl();
            hddPageIndex.Value = "1";
            LoadData();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void DropKQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal kqID = Convert.ToDecimal(DropKQ.SelectedValue);
                FillThuTu(GetListLyDoByKetQua(kqID).Count + 1);
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
            DM_KETQUA_PHUCTHAM_LYDO lyDo = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.ID == LyDoID).FirstOrDefault<DM_KETQUA_PHUCTHAM_LYDO>();
            if (lyDo == null)
            {
                isNew = true;
                lyDo = new DM_KETQUA_PHUCTHAM_LYDO();
                lyDo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                lyDo.NGAYTAO = DateTime.Now;
            }
            else
            {
                lyDo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                lyDo.NGAYSUA = DateTime.Now;
            }
            lyDo.KETQUAID = Convert.ToDecimal(DropKQ.SelectedValue);
            lyDo.MA = txtMa.Text.Trim();
            lyDo.TEN = txtTen.Text.Trim();
            lyDo.GHICHU = txtGhiChu.Text.Trim();
            lyDo.THUTU = Convert.ToDecimal(DropThuTu.SelectedValue);
            if (isNew)
            {
                dt.DM_KETQUA_PHUCTHAM_LYDO.Add(lyDo);
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
            txtMa.Text = txtTen.Text = txtGhiChu.Text = lbthongbao.Text = "";
            decimal kqID = Convert.ToDecimal(DropKQ.SelectedValue);
            FillThuTu(GetListLyDoByKetQua(kqID).Count + 1);
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
        private List<DM_KETQUA_PHUCTHAM_LYDO> GetListLyDoByKetQua(decimal kqID)
        {
            return dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.KETQUAID == kqID).ToList();
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
            DM_KETQUA_PHUCTHAM_LYDO LyDo = new DM_KETQUA_PHUCTHAM_LYDO();
            foreach (DataGridItem oItem in dgList.Items)
            {
                LyDoID = Convert.ToDecimal(oItem.Cells[ColIDIndex].Text);
                LyDo = dt.DM_KETQUA_PHUCTHAM_LYDO.Where(x => x.ID == LyDoID).FirstOrDefault<DM_KETQUA_PHUCTHAM_LYDO>();
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
            if (DropKQ.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!";
                DropKQ.Focus();
                return false;
            }
            int lengthMa = txtMa.Text.Trim().Length;
            if (lengthMa == 0 || lengthMa > 50)
            {
                lbthongbao.Text = "Mã lý do không được trống hoặc quá 50 ký tự. Hãy nhập lại!";
                txtMa.Focus();
                return false;
            }
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen == 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Tên lý do không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                txtTen.Focus();
                return false;
            }
            int lengthGhiChu = txtGhiChu.Text.Trim().Length;
            if (lengthGhiChu > 250)
            {
                lbthongbao.Text = "Ghi chú không được quá 250 ký tự. Hãy nhập lại!";
                txtGhiChu.Focus();
                return false;
            }
            return true;
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx?pg=" + Request["pg"]);
        }


    }
}