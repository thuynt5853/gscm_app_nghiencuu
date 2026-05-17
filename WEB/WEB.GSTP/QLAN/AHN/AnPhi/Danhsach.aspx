<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs"
Inherits="WEB.GSTP.QLAN.AHN.AnPhi.Danhsach" %> <%@ Register
Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content
  ID="Content2"
  ContentPlaceHolderID="ContentPlaceHolder1"
  runat="server"
>
  <script src="../../../UI/js/Common.js"></script>
  <style>
    .lable_td {
      width: 160px;
    }

    .checkbox {
      width: 100%;
    }

    .checkbox label {
      margin-left: 5px;
    }
  </style>
  <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
  <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
  <asp:HiddenField ID="hddNgayGQYC" Value="" runat="server" />
  <asp:HiddenField ID="hddShowNopAnPhi" runat="server" Value="0" />
  <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
  <div class="box">
    <div class="box_nd">
      <asp:Panel ID="pnThongTinAnPhi" runat="server">
        <div class="boxchung">
          <h4 class="tleboxchung">Thông tin án phí</h4>
          <div class="boder" style="padding: 10px">
            <table class="table1">
              <tr>
                <td>Miễn án phí</td>
                <td colspan="3">
                  <asp:CheckBox
                    ID="chkNopAnPhi"
                    runat="server"
                    Text=""
                    AutoPostBack="True"
                    OnCheckedChanged="chkNopAnPhi_CheckedChanged"
                  />
                </td>
              </tr>
              <tr>
                <td class="lable_td">Giá trị tranh chấp</td>
                <td style="width: 175px">
                  <asp:TextBox
                    ID="txtGiaTriTranhChap"
                    runat="server"
                    Enabled="false"
                    CssClass="user align_right"
                    Width="150px"
                    onkeypress="return isNumber(event)"
                    onkeyup="javascript:this.value=Comma(this.value);"
                  ></asp:TextBox>
                </td>
                <td style="width: 120px">Mức giảm án phí</td>
                <td>
                  <asp:TextBox
                    ID="txtMucGiamAnPhi"
                    runat="server"
                    CssClass="user align_right"
                    Width="185px"
                    Enabled="false"
                    onkeyup="javascript:this.value=Comma(this.value);"
                    onkeypress="return isNumber(event)"
                  ></asp:TextBox>
                </td>
              </tr>
              <tr>
                <td>Án phí</td>
                <td>
                  <asp:TextBox
                    ID="txtAnPhi"
                    runat="server"
                    CssClass="user align_right"
                    Width="150px"
                    Enabled="false"
                    onkeyup="javascript:this.value=Comma(this.value);"
                    onkeypress="return isNumber(event)"
                  ></asp:TextBox>
                </td>
                <td>Tạm ứng án phí</td>
                <td>
                  <asp:TextBox
                    ID="txtTamUngAnPhi"
                    runat="server"
                    CssClass="user align_right"
                    Enabled="false"
                    onkeyup="javascript:this.value=Comma(this.value);"
                    Width="185px"
                    onkeypress="return isNumber(event)"
                  ></asp:TextBox>
                </td>
              </tr>
              <tr>
                <td>Hạn nộp</td>
                <td>
                  <asp:TextBox
                    ID="txtHanNopAnPhi"
                    runat="server"
                    CssClass="user"
                    Enabled="false"
                    Width="150px"
                    MaxLength="10"
                  ></asp:TextBox>
                  <ajaxToolkit:CalendarExtender
                    ID="cl1"
                    runat="server"
                    TargetControlID="txtHanNopAnPhi"
                    Format="dd/MM/yyyy"
                    Enabled="true"
                  />
                  <ajaxToolkit:MaskedEditExtender
                    ID="MaskedEditExtender3"
                    runat="server"
                    TargetControlID="txtHanNopAnPhi"
                    Mask="99/99/9999"
                    MaskType="Date"
                    CultureName="vi-VN"
                    ErrorTooltipEnabled="true"
                  />
                </td>
                <td>Số ngày gia hạn</td>
                <td>
                  <asp:TextBox
                    ID="txtSoNgayGiaHan"
                    runat="server"
                    CssClass="user align_right"
                    Width="185px"
                    Enabled="false"
                    onkeypress="return isNumber(event)"
                  ></asp:TextBox>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </asp:Panel>
      <div class="boxchung">
        <h4 class="tleboxchung">Thông tin biên lai án phí</h4>
        <div class="boder" style="padding: 10px">
          <div id="zone_nopanphi">
            <table class="table1">
              <tr>
                <td class="lable_td">Đương sự</td>
                <td style="width: 150px">
                  <asp:DropDownList
                    ID="ddlDuongSu"
                    CssClass="chosen-select"
                    runat="server"
                    Width="158px"
                    AutoPostBack="True"
                    OnSelectedIndexChanged="ddlDuongSu_SelectedIndexChanged"
                  >
                  </asp:DropDownList>
                </td>
                <td class="lable_td">Người nộp</td>
                <td>
                  <asp:TextBox
                    ID="txtNguoiNop"
                    runat="server"
                    CssClass="user"
                    Width="185px"
                  ></asp:TextBox>
                </td>
              </tr>

              <tr>
                <td class="lable_td">
                  Ngày nộp tạm ứng án phí<span class="must_input">(*)</span>
                </td>
                <td>
                  <asp:TextBox
                    ID="txtNgayNopAnPhi"
                    runat="server"
                    CssClass="user"
                    Width="150px"
                    MaxLength="10"
                    AutoPostBack="true"
                    OnTextChanged="txtNgayNopAnPhi_TextChanged"
                  ></asp:TextBox>
                  <ajaxToolkit:CalendarExtender
                    ID="CalendarExtender3"
                    runat="server"
                    TargetControlID="txtNgayNopAnPhi"
                    Format="dd/MM/yyyy"
                    Enabled="true"
                  />
                  <ajaxToolkit:MaskedEditExtender
                    ID="MaskedEditExtender5"
                    runat="server"
                    TargetControlID="txtNgayNopAnPhi"
                    Mask="99/99/9999"
                    MaskType="Date"
                    CultureName="vi-VN"
                    ErrorTooltipEnabled="true"
                  />
                </td>
                <td>Người nhận</td>
                <td>
                  <asp:DropDownList
                    ID="ddlNguoiNhan"
                    CssClass="chosen-select"
                    runat="server"
                    Width="193px"
                  ></asp:DropDownList>
                </td>
              </tr>
              <tr>
                <td class="lable_td">
                  Số biên lai<span class="must_input">(*)</span>
                </td>
                <td style="width: 175px">
                  <asp:TextBox
                    ID="txtSoBienLai"
                    runat="server"
                    CssClass="user"
                    Width="150px"
                    MaxLength="10"
                  ></asp:TextBox>
                </td>
                <td style="width: 120px">
                  Ngày nộp biên lai<span class="must_input">(*)</span>
                </td>
                <td>
                  <asp:TextBox
                    ID="txtNgayNopBL"
                    runat="server"
                    CssClass="user"
                    Width="185px"
                    MaxLength="10"
                  ></asp:TextBox>
                  <ajaxToolkit:CalendarExtender
                    ID="CalendarExtender2"
                    runat="server"
                    TargetControlID="txtNgayNopBL"
                    Format="dd/MM/yyyy"
                    Enabled="true"
                  />
                  <ajaxToolkit:MaskedEditExtender
                    ID="MaskedEditExtender4"
                    runat="server"
                    TargetControlID="txtNgayNopBL"
                    Mask="99/99/9999"
                    MaskType="Date"
                    CultureName="vi-VN"
                    ErrorTooltipEnabled="true"
                  />
                </td>
              </tr>
              <tr>
                <td class="lable_td">Số thông báo</td>
                <td>
                  <asp:TextBox
                    ID="txtSoThongBao"
                    runat="server"
                    CssClass="user"
                    Width="150px"
                    MaxLength="10"
                    Enabled="false"
                  ></asp:TextBox>
                </td>
                <td>Ngày thông báo</td>
                <td>
                  <asp:TextBox
                    ID="txtNgayThongBao"
                    runat="server"
                    CssClass="user"
                    Width="185px"
                    MaxLength="10"
                  ></asp:TextBox>
                  <ajaxToolkit:CalendarExtender
                    ID="CalendarExtender1"
                    runat="server"
                    TargetControlID="txtNgayThongBao"
                    Format="dd/MM/yyyy"
                    Enabled="true"
                  />
                  <ajaxToolkit:MaskedEditExtender
                    ID="MaskedEditExtender1"
                    runat="server"
                    TargetControlID="txtNgayThongBao"
                    Mask="99/99/9999"
                    MaskType="Date"
                    CultureName="vi-VN"
                    ErrorTooltipEnabled="true"
                  />
                </td>
              </tr>
              <tr>
                <td colspan="6">
                  <div style="text-align: center; margin-top: 5px">
                    <asp:Button
                      ID="cmdCapNhat"
                      runat="server"
                      CssClass="buttoninput"
                      Text="Lưu"
                      OnClick="cmdCapNhat_Click"
                      OnClientClick=" return Validate();"
                    />
                    <%--<asp:Button
                      ID="cmdxoa"
                      runat="server"
                      CssClass="buttoninput"
                      Text="Xóa"
                      OnClick="cmdxoa_Click"
                    />--%>
                    <asp:Button
                      ID="cmdThuLy"
                      runat="server"
                      Visible="false"
                      CssClass="buttoninput"
                      Text="Thụ lý"
                      OnClick="cmdThuLy_Click"
                    />
                  </div>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <asp:Label
                    runat="server"
                    ID="lbtthongbao"
                    ForeColor="Red"
                    Style="margin-left: 15px;"
                  ></asp:Label>
                </td>
              </tr>
              <tr>
                <td colspan="6">
                  <asp:HiddenField ID="hddCurrID" runat="server" />
                  <div class="phantrang">
                    <div class="sobanghi">
                      <asp:Literal
                        ID="lstSobanghiT"
                        runat="server"
                      ></asp:Literal>
                    </div>
                    <div class="sotrang">
                      <asp:LinkButton
                        ID="lbTBack"
                        runat="server"
                        CausesValidation="false"
                        CssClass="back"
                        Visible="false"
                        OnClick="lbTBack_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbTFirst"
                        runat="server"
                        CausesValidation="false"
                        CssClass="active"
                        Visible="false"
                        Text="1"
                        OnClick="lbTFirst_Click"
                      ></asp:LinkButton>

                      <asp:Label
                        ID="lbTStep1"
                        runat="server"
                        Text="..."
                        Visible="false"
                      ></asp:Label>

                      <asp:LinkButton
                        ID="lbTStep2"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="2"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbTStep3"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="3"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbTStep4"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="4"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbTStep5"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="5"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:Label
                        ID="lbTStep6"
                        runat="server"
                        Text="..."
                        Visible="false"
                      ></asp:Label>
                      <asp:LinkButton
                        ID="lbTLast"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="100"
                        OnClick="lbTLast_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbTNext"
                        runat="server"
                        CausesValidation="false"
                        CssClass="next"
                        Visible="false"
                        OnClick="lbTNext_Click"
                      ></asp:LinkButton>
                    </div>
                  </div>
                  <div>
                    <asp:DataGrid
                      ID="rpt"
                      runat="server"
                      AutoGenerateColumns="False"
                      CellPadding="4"
                      PageSize="20"
                      AllowPaging="True"
                      GridLines="None"
                      PagerStyle-Mode="NumericPages"
                      CssClass="table2"
                      HeaderStyle-CssClass="header"
                      AlternatingItemStyle-CssClass="le"
                      ItemStyle-CssClass="chan"
                      Width="100%"
                      OnItemCommand="rpt_ItemCommand"
                      OnItemDataBound="rpt_ItemDataBound"
                    >
                      <Columns>
                        <asp:TemplateColumn
                          HeaderStyle-Width="20px"
                          ItemStyle-Width="20px"
                          HeaderStyle-HorizontalAlign="Center"
                          ItemStyle-HorizontalAlign="Center"
                        >
                          <HeaderTemplate> TT </HeaderTemplate>
                          <ItemTemplate>
                            <%# Container.DataSetIndex + 1 %>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-HorizontalAlign="Center"
                        >
                          <HeaderTemplate>
                            Nguyên đơn/ Người KK
                          </HeaderTemplate>
                          <ItemTemplate> <%#Eval("DUONGSU") %> </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-HorizontalAlign="Center"
                          ItemStyle-HorizontalAlign="Right"
                        >
                          <HeaderTemplate> Tạm ứng AP </HeaderTemplate>
                          <ItemTemplate> <%#Eval("TAMUNGAP") %> </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-HorizontalAlign="Center"
                          ItemStyle-HorizontalAlign="left"
                          HeaderStyle-Width="120px"
                        >
                          <HeaderTemplate>Biên lai trực tuyến</HeaderTemplate>
                          <ItemTemplate>
                            <%-- <br />
                            Người nộp: <%#Eval("HOTENNGUOINOPTIEN") %>
                            <div>
                              Ngày biên lai:<%#Eval("THOIGIANTHANHTOAN") %>
                            </div>
                            --%>
                            <div>
                              <asp:ImageButton
                                ID="lblDownloadAP"
                                ImageUrl="/UI/img/Manager/file_attach_pdf.gif"
                                runat="server"
                                CausesValidation="false"
                                CommandName="DownloadAP"
                                CommandArgument='<%#Eval("FILEID") %>'
                                ToolTip='<%#Eval("TENFILE")%>'
                              />
                              <asp:HiddenField
                                ID="hd_DownloadAP"
                                runat="server"
                                Value='<%#Eval("MA_THONGBAO").ToString()+";"+Eval("DVCQG_TT_ID") %>'
                              />
                            </div>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-HorizontalAlign="Center"
                          ItemStyle-HorizontalAlign="left"
                          HeaderStyle-Width="300px"
                        >
                          <HeaderTemplate
                            >Thông tin biên lai trực tiếp (THA)</HeaderTemplate
                          >
                          <ItemTemplate>
                            <div>
                              <i>Mã thông báo:</i>
                              <b><%#Eval("MA_THONGBAO") %></b>
                              <br />
                              <i> Số biên lai: </i> <%#Eval("SOBIENLAI") %>
                              <br />
                              <i> Ngày biên lai:</i> <%#Eval("NGAYNOPBIENLAI")
                              %>
                              <br />
                              <i> Người nộp: </i> <%#Eval("NGUOINOP") %>
                              <br />
                              <i> Ngày nộp tạm ứng án phí:</i> <%#
                              string.Format("{0:dd/MM/yyyy}",Eval("NGAYNOPANPHI"))
                              %>
                            </div>
                            <div style="margin-top: 5px">
                              <asp:ImageButton
                                ID="lblDownloadAP_THA"
                                ImageUrl="/UI/img/Manager/pdf_blues.png"
                                runat="server"
                                CausesValidation="false"
                                CommandName="DownloadAP_THA"
                                CommandArgument='<%#Eval("ANPHI_ID") %>'
                                ToolTip='<%#Eval("TENFILE")%>'
                              />
                            </div>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-Width="80px"
                          HeaderStyle-HorizontalAlign="Center"
                        >
                          <HeaderTemplate> Người tạo </HeaderTemplate>
                          <ItemTemplate> <%# Eval("NguoiTao") %> </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-Width="80px"
                          HeaderStyle-HorizontalAlign="Center"
                          ItemStyle-HorizontalAlign="Center"
                        >
                          <HeaderTemplate> Ngày tạo </HeaderTemplate>
                          <ItemTemplate>
                            <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao"))
                            %>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn
                          HeaderStyle-Width="105px"
                          HeaderStyle-HorizontalAlign="Center"
                          ItemStyle-HorizontalAlign="Center"
                        >
                          <HeaderTemplate> Thao tác </HeaderTemplate>
                          <ItemTemplate>
                            <div>
                              <asp:ImageButton
                                ID="cmdENABLE"
                                runat="server"
                                CausesValidation="false"
                                CommandArgument='<%#Eval("ID") %>'
                                CommandName="ENABLE"
                                ImageUrl="/UI/img/Manager/lock.png"
                              />
                            </div>

                            <div style="margin-top: 12px">
                              <asp:LinkButton
                                ID="lblSua"
                                runat="server"
                                Text="Sửa"
                                CausesValidation="false"
                                CommandName="Sua"
                                ForeColor="#0e7eee"
                                CommandArgument='<%#Eval("ID") %>'
                              ></asp:LinkButton>
                              &nbsp;&nbsp;<asp:LinkButton
                                ID="lbtXoa"
                                runat="server"
                                CausesValidation="false"
                                Text="Xóa"
                                ForeColor="#0e7eee"
                                CommandName="Xoa"
                                CommandArgument='<%#Eval("ID") %>'
                                ToolTip="Xóa"
                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"
                              ></asp:LinkButton>
                            </div>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:BoundColumn
                          DataField="TOA_GIAIQUYET_ID"
                          Visible="false"
                        ></asp:BoundColumn>
                      </Columns>
                      <HeaderStyle CssClass="header"></HeaderStyle>
                      <ItemStyle CssClass="chan"></ItemStyle>
                      <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                  </div>
                  <div class="phantrang">
                    <div class="sobanghi">
                      <asp:Literal
                        ID="lstSobanghiB"
                        runat="server"
                      ></asp:Literal>
                    </div>
                    <div class="sotrang">
                      <asp:LinkButton
                        ID="lbBBack"
                        runat="server"
                        CausesValidation="false"
                        CssClass="back"
                        Visible="false"
                        OnClick="lbTBack_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbBFirst"
                        runat="server"
                        CausesValidation="false"
                        CssClass="active"
                        Visible="false"
                        Text="1"
                        OnClick="lbTFirst_Click"
                      ></asp:LinkButton>
                      <asp:Label
                        ID="lbBStep1"
                        runat="server"
                        Text="..."
                        Visible="false"
                      ></asp:Label>
                      <asp:LinkButton
                        ID="lbBStep2"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="2"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbBStep3"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="3"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbBStep4"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="4"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbBStep5"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="5"
                        OnClick="lbTStep_Click"
                      ></asp:LinkButton>
                      <asp:Label
                        ID="lbBStep6"
                        runat="server"
                        Text="..."
                        Visible="false"
                      ></asp:Label>
                      <asp:LinkButton
                        ID="lbBLast"
                        runat="server"
                        CausesValidation="false"
                        CssClass="so"
                        Visible="false"
                        Text="100"
                        OnClick="lbTLast_Click"
                      ></asp:LinkButton>
                      <asp:LinkButton
                        ID="lbBNext"
                        runat="server"
                        CausesValidation="false"
                        CssClass="next"
                        Visible="false"
                        OnClick="lbTNext_Click"
                      ></asp:LinkButton>
                    </div>
                  </div>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </div>
      <%--
      <div class="truong" style="text-align: center">
        <asp:Button
          ID="cmdCapNhat"
          runat="server"
          CssClass="buttoninput"
          Text="Lưu"
          OnClick="cmdCapNhat_Click"
          OnClientClick=" return Validate();"
        />
        <asp:Button
          ID="cmdxoa"
          runat="server"
          CssClass="buttoninput"
          Text="Xóa"
          OnClick="cmdxoa_Click"
        />
        <asp:Button
          ID="cmdThuLy"
          runat="server"
          Visible="false"
          CssClass="buttoninput"
          Text="Thụ lý"
          OnClick="cmdThuLy_Click"
        />
      </div>
      --%> <%--<asp:Label
        runat="server"
        ID="lbtthongbao"
        ForeColor="Red"
        Style="margin-left: 15px;"
      ></asp:Label
      >--%>
    </div>
  </div>
  <script>
    function pageLoad(sender, args) {
      var config = {
        ".chosen-select": {},
        ".chosen-select-deselect": { allow_single_deselect: true },
        ".chosen-select-no-single": { disable_search_threshold: 10 },
        ".chosen-select-no-results": {
          no_results_text: "Oops, nothing found!",
        },
        ".chosen-select-rtl": { rtl: true },
        ".chosen-select-width": { width: "95%" },
      };
      for (var selector in config) {
        $(selector).chosen(config[selector]);
      }
    }
    function Validate() {
      //-------------------check zone nop an phi----------------------
      var chkNopAnPhi = document.getElementById("<%= chkNopAnPhi.ClientID %>");
      if (!chkNopAnPhi.checked) {
        var txtNgayNopAnPhi = document.getElementById(
          "<%=txtNgayNopAnPhi.ClientID %>"
        );
        if (!CheckDateTimeControl(txtNgayNopAnPhi, "Ngày nộp tạm ứng án phí"))
          return false;
        var ddlNguoiNhan = document.getElementById(
          "<%=ddlNguoiNhan.ClientID%>"
        );
        var val = ddlNguoiNhan.options[ddlNguoiNhan.selectedIndex].value;
        if (val == 0) {
          alert("Chưa chọn cán bộ nhận biên lai. Hãy chọn lại!");
          ddlNguoiNhan.focus();
          return false;
        }
        var txtSoBienLai = document.getElementById(
          "<%=txtSoBienLai.ClientID %>"
        );
        if (!Common_CheckEmpty(txtSoBienLai.value)) {
          alert("Chưa nhập số biên lai. Hãy nhập lại!");
          txtSoBienLai.focus();
          return false;
        }
        var txtNgayNopBL = document.getElementById(
          "<%=txtNgayNopBL.ClientID %>"
        );
        if (!CheckDateTimeControl(txtNgayNopBL, "Ngày nộp biên lai"))
          return false;
        if (!SoSanhDate(txtNgayNopBL, txtNgayNopAnPhi)) {
          alert(
            "Ngày nộp biên lai phải lớn hơn hoặc bằng ngày nộp tạm ứng án phí. Hãy nhập lại!"
          );
          return false;
        }
      }

      return true;
    }
  </script>
</asp:Content>

