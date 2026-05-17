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
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    FillThuTu(GetListKetQuaPhucTham().Count + 1);
                    if (Request["pg"] != null)
                    {
                        hddPageIndex.Value = Request["pg"].ToString();
                    }
                    else
                    {
                        hddPageIndex.Value = "1";
                    }
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            string TextKey = txtTimKiem.Text.Trim();
            int pageIndex = Convert.ToInt32(hddPageIndex.Value), pageSize = Convert.ToInt32(hddPageSize.Value);
            DM_KETQUA_PHUCTHAM_BL oBL = new DM_KETQUA_PHUCTHAM_BL();
            DataTable lst = oBL.DM_KETQUA_PHUCTHAM_SEARCH(TextKey, pageIndex, pageSize);
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
                    case "LyDo":
                        Response.Redirect("LyDo.aspx?kq=" + curr_id + "&pg=" + hddPageIndex.Value);
                        break;
                    case "Sua":
                        LoadEdit(curr_id);
                        hddKqID.Value = e.CommandArgument.ToString();
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
                    decimal countItem = 0, ThuTu = 0;
                    List<DM_KETQUA_PHUCTHAM> lst = dt.DM_KETQUA_PHUCTHAM.ToList();
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
            DM_KETQUA_PHUCTHAM kqPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ID == id).FirstOrDefault<DM_KETQUA_PHUCTHAM>();
            if (kqPT != null)
            {
                txtMa.Text = kqPT.MA;
                txtTen.Text = kqPT.TEN;
                txtGhiChu.Text = kqPT.GHICHU;
                DropThuTu.SelectedValue = kqPT.THUTU.ToString();
                chkHinhSu.Checked = string.IsNullOrEmpty(kqPT.ISAHS + "") ? false : Convert.ToBoolean(kqPT.ISAHS);
                chkDanSu.Checked = string.IsNullOrEmpty(kqPT.ISADS + "") ? false : Convert.ToBoolean(kqPT.ISADS);
                chkHonNhanGD.Checked = string.IsNullOrEmpty(kqPT.ISAHN + "") ? false : Convert.ToBoolean(kqPT.ISAHN);
                chkKDTM.Checked = string.IsNullOrEmpty(kqPT.ISAKT + "") ? false : Convert.ToBoolean(kqPT.ISAKT);
                chkLaoDong.Checked = string.IsNullOrEmpty(kqPT.ISALD + "") ? false : Convert.ToBoolean(kqPT.ISALD);
                chkHanhChinh.Checked = string.IsNullOrEmpty(kqPT.ISAHC + "") ? false : Convert.ToBoolean(kqPT.ISAHC);
                chkPhasan.Checked = string.IsNullOrEmpty(kqPT.ISAPS + "") ? false : Convert.ToBoolean(kqPT.ISAPS);
                chkXLHC.Checked = string.IsNullOrEmpty(kqPT.ISXLHC + "") ? false : Convert.ToBoolean(kqPT.ISXLHC);
            }
        }
        private void Xoa(decimal id)
        {
            DM_KETQUA_PHUCTHAM kqPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ID == id).FirstOrDefault<DM_KETQUA_PHUCTHAM>();
            if (kqPT != null)
            {
                dt.DM_KETQUA_PHUCTHAM.Remove(kqPT);
                dt.SaveChanges();
            }
            ResetControl();
            hddPageIndex.Value = "1";
            LoadData();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            if (!ValidateData())
            {
                return;
            }
            decimal KqID = Convert.ToDecimal(hddKqID.Value);
            bool isNew = false;
            DM_KETQUA_PHUCTHAM Kq = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ID == KqID).FirstOrDefault<DM_KETQUA_PHUCTHAM>();
            if (Kq == null)
            {
                isNew = true;
                Kq = new DM_KETQUA_PHUCTHAM();
                Kq.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Kq.NGAYTAO = DateTime.Now;
            }
            else
            {
                Kq.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Kq.NGAYSUA = DateTime.Now;
            }
            Kq.MA = txtMa.Text.Trim();
            Kq.TEN = txtTen.Text.Trim();
            Kq.GHICHU = txtGhiChu.Text.Trim();
            Kq.THUTU = Convert.ToDecimal(DropThuTu.SelectedValue);
            Kq.ISAHS = chkHinhSu.Checked ? 1 : 0;
            Kq.ISADS = chkDanSu.Checked ? 1 : 0;
            Kq.ISAHN = chkHonNhanGD.Checked ? 1 : 0;
            Kq.ISAKT = chkKDTM.Checked ? 1 : 0;
            Kq.ISALD = chkLaoDong.Checked ? 1 : 0;
            Kq.ISAHC = chkHanhChinh.Checked ? 1 : 0;
            Kq.ISAPS = chkPhasan.Checked ? 1 : 0;
            Kq.ISXLHC = chkXLHC.Checked ? 1 : 0;
            if (isNew)
            {
                dt.DM_KETQUA_PHUCTHAM.Add(Kq);
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
                decimal KqID = Convert.ToDecimal(hddKqID.Value);
                Xoa(KqID);
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
            FillThuTu(GetListKetQuaPhucTham().Count + 1);
            hddKqID.Value = "0";
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
        private List<DM_KETQUA_PHUCTHAM> GetListKetQuaPhucTham()
        {
            return dt.DM_KETQUA_PHUCTHAM.ToList();
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
            decimal kqID = 0;
            DM_KETQUA_PHUCTHAM kq = new DM_KETQUA_PHUCTHAM();
            foreach (DataGridItem oItem in dgList.Items)
            {
                kqID = Convert.ToDecimal(oItem.Cells[ColIDIndex].Text);
                kq = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ID == kqID).FirstOrDefault<DM_KETQUA_PHUCTHAM>();
                DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                kq.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                kq.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                kq.NGAYSUA = DateTime.Now;
                dt.SaveChanges();
            }
            hddPageIndex.Value = "1";
            LoadData();
        }
        private bool ValidateData()
        {
            int lengthMa = txtMa.Text.Trim().Length;
            if (lengthMa == 0 || lengthMa > 20)
            {
                lbthongbao.Text = "Mã kết quả không được trống hoặc quá 20 ký tự. Hãy nhập lại!";
                txtMa.Focus();
                return false;
            }
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen == 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Kết quả không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
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
    }
}