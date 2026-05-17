<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThemMoi_DonAnTH.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.AnTH.ThemMoi_DonAnTH" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="Hi_update" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnIDchon" runat="server" Value="0" />
    <asp:HiddenField ID="hddDuongSuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddHOSO_ANGIAM_ID" runat="server" Value="0" />
    <asp:HiddenField ID="hhdcheckDS" runat="server" Value="0" />
    <asp:HiddenField ID="hddIsAnPT" runat="server" Value="PT" />
    <script src="../../../../UI/js/Common.js"></script>
    <div class="box">
        <div class="box_nd">
            <div class="truong">


                 <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin bản án hiệu lực pháp luật</h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
                            <table class="tableva">
                                <tr>
                                    <td style="width: 120px;text-align:right;padding-right:10px">Loại bản án</td>
                                    <td style="width: 255px;padding-bottom:5px" colspan="3">
                                        <asp:DropDownList ID="ddlLoaiBA" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiBA_SelectedIndexChanged"
                                            runat="server" Width="250px">
                                            <asp:ListItem Value="3" Text="Phúc thẩm" Selected ="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Sơ thẩm"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="QĐ GĐT"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    
                                </tr>
                                 <!---------------QĐ GDT----------------------------->
                                <asp:Panel ID="pnQDGDT" runat="server" Visible ="false">
                                    <tr>
                                        <td style="width: 120px;padding-bottom:5px;text-align:right;padding-right:10px">Số QĐ GĐT
                                    <asp:Literal ID="ltt_SoGDT" runat="server" Text="<span class='batbuoc'></span>"></asp:Literal>
                                        </td>
                                        <td style="width: 255px;padding-bottom:5px">
                                            <asp:TextBox ID="txtSoQĐGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>

                                        <td style="width: 95px;">Ngày QĐ GĐT<asp:Literal ID="ltt_NgayGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:TextBox ID="txtNgayGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtNgayGDT" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtNgayGDT"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án ra QĐ GDT<asp:Literal ID="ltt_ToaGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:DropDownList ID="dropToaGDT" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaGDT_SelectedIndexChanged"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr><td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td></tr>
                                </asp:Panel>
                                <!---------------An PT----------------------------->
                                <asp:Panel ID="pnPhucTham" runat="server">
                                    <tr>
                                        <td style="width: 120px;text-align:right;padding-right:10px">Số BA/QĐ
                                    <asp:Literal ID="lttBB_SoPT" runat="server" Text="<span class='batbuoc'></span>"></asp:Literal>
                                        </td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtSoBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td style="width: 95px;">Ngày  BA/QĐ<asp:Literal ID="lttBB_NgayPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:TextBox ID="txtNgayBA" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBA"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td  style="width: 120px;text-align:right;padding-right:10px">Tòa án BA/QĐ<asp:Literal ID="lttBB_ToaPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                </asp:Panel>
                                <!-----------An ST--------------------------------->
                                <asp:Panel ID="pnAnST" runat="server">
                                    <tr>
                                        <td style="width: 120px;text-align:right;padding-right:10px;padding-bottom:5px">Số BA Sơ thẩm
                                <asp:Literal ID="lttBB_SoST" runat="server" Visible="false" Text="<span class='batbuoc'></span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:TextBox ID="txtSoBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td>Ngày BA Sơ thẩm
                                <asp:Literal ID="lttBB_NgayST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:TextBox ID="txtNgayBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayBA_ST" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayBA_ST"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 120px;text-align:right;padding-right:10px">Tòa án xét xử ST
                                            <asp:Literal ID="lttBB_ToaST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                        <td style="padding-bottom:5px">
                                            <asp:DropDownList ID="dropToaAnST" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                        <td><asp:Button ID="cmdCheckVuAn" runat="server" Text="Kiểm tra" OnClick="cmdCheckVuAn_Click"  OnClientClick="return validate_banan_qd();"  CssClass="buttoninput" Height="25px"/> </td>
                                        <td>
                                            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="buttonpopup them_user clear_bottom"
                                            ToolTip="Thêm bị án" OnClick="lkThemDSAnHS_Click">Thêm Bị án</asp:LinkButton>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </div>
               </div>
                <!------------Danh sach Ban án ---------------->
                <asp:Panel ID="pnBanan" runat="server">
                        <div class="boxchung">
                  
                           <asp:DataGrid ID="dgDsVuan" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan"  OnItemCommand="dgDsVuan_ItemCommand"  OnItemDataBound="dgDsVuan_ItemDataBound">
                                        <Columns>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px">
                                               <HeaderTemplate>                   
                                               </HeaderTemplate>
                                               <ItemTemplate>
                                                    <asp:Button ID="cmdChonVuan" runat="server" Text="Chọn" CssClass="buttonchitiet" CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("vuanid")%>' />  
                                               </ItemTemplate>
                                               <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                               <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>TT</HeaderTemplate>
                                                <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>

                                            </asp:TemplateColumn>
                                           <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                                <ItemTemplate>
                                                    <b><%#Eval("SOANPHUCTHAM")%></b>
                                                    <br />
                                                    <%#Eval("NGAYXUPHUCTHAM", "{0:dd/MM/yyyy}")%>
                                                    <br />
                                                    <%#Eval("TOAXETXU")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                             <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="60px" ></asp:BoundColumn>
                                            <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="60px" ></asp:BoundColumn>

                                            <asp:BoundColumn DataField="TOIDANH" HeaderText="Tội danh" HeaderStyle-Width="60px" ></asp:BoundColumn>
                                           <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thẩm tra viên<br />
                                                    Lãnh đạo Vụ<br />
                                                    Thẩm phán
                                               
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"")? "":("TTV:<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>
                                                    <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                                    <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>                            
                                   
                                        </Columns>
                                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>  

                      </div>
                </asp:Panel>
               <!---------Them Bị an của Vu an------------------->
              <div class="boxchung">
                <asp:Panel ID="pnThemBian" runat="server" Visible="false">           
                        <h4 class="tleboxchung" style="top: 2px;">Thêm Bị cáo</h4>
                         <div class="boder" style="padding: 10px;">
                            <div style="width: 100%">
                              <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Họ tên<span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtBC_HoTen" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Năm sinh<span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <asp:DropDownList ID="ddlNamsinh" CssClass="chosen-select"
                                                runat="server" Width="245px"></asp:DropDownList>
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Địa chỉ<span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtDiachi" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Tội danh<span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <span style="float: left;">
                                                    <asp:DropDownList ID="dropBiCao_ToiDanh" runat="server"
                                                        CssClass="chosen-select" Width="510px">
                                                    </asp:DropDownList></span>
                                    </div>
                                </div>
                                
                            </div>
                            <div style="clear: both;"></div>
                        </div>             
                </asp:Panel>
              </div>
                <!---------------------------->
                <%--Hien thị Bi an theo vu an-----------------------------%>
                <asp:Panel ID="pnDSBian" runat="server"> 
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Bị án tử hình</h4>
                        <div class="boder" style="padding: 10px;" >
                             <table class="tableva">
                                <tr>
                                    <td style="width: 1024px">
                            <asp:DataGrid ID="dgListDuongSu" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                PageSize="5" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgListDuongSu_ItemCommand" OnItemDataBound="dgListDuongSu_ItemDataBound">
                                                <Columns>
                                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px">
                                                        <HeaderTemplate>
                                                            
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:Button ID="cmdChitiet" runat="server" Text="Chọn đương sự" CssClass="buttonchitiet" CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("ID")+ "#" + Eval("vuanid")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="TENDUONGSU" HeaderText="Tên Đương Sự" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="125px"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="NAMSINH" HeaderText="Năm sinh" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="125px"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="diachi" HeaderText="Địa chỉ" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="HS_TENTOIDANH" HeaderText="Tội danh" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="300px"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="hs_mucan" HeaderText="Mức án" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px"></asp:BoundColumn>

                                                </Columns>
                                                <HeaderStyle CssClass="header"></HeaderStyle>
                                                <ItemStyle CssClass="chan"></ItemStyle>
                                                <PagerStyle Visible="false"></PagerStyle>
                                            </asp:DataGrid>
                                        </td>
                                    </tr>
                                 </table>
                            </div>
                          </div>
                      </asp:Panel>          


                <div class="boxchung">
                    <asp:Panel ID="pnThuLyDon" runat="server">
                        <h4 class="tleboxchung" style="top: 2px;">Thông tin thụ lý đơn xin ân giảm</h4>
                        <div class="boder" style="padding: 10px;">
                            <div style="width: 100%">
                                <div style="float: left; width: 900px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Loại đơn<span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <asp:DropDownList runat="server" ID="Drop_LOAI"
                                            Width="229px" CssClass="chosen-select">
                                            <asp:ListItem Value="" Text="--- Chọn ---" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Xin ân giảm"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Xin ân giảm + kêu oan"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Xin thi hành án"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Người nhận đơn</div>
                                    <div style="float: left;">
                                        <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlThamtravien_SelectedIndexChanged"
                                            runat="server" Width="230px">
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Ngày nhận đơn<span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNgaynhandon" runat="server" CssClass="user" Width="162px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaynhandon"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaynhandon"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Người gửi đơn</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                    </div>
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Ngày ghi trên đơn <span class="batbuoc">*</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNgayghidon" runat="server" CssClass="user" Width="162px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayghidon" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayghidon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Địa chỉ người gửi</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txt_DiachiNguoigui" runat="server" CssClass="user" Width="520px" MaxLength="250"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="float: left; width: 900px; margin-top: 7px;">
                                    <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Nội dung đơn</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNoidung" CssClass="user" runat="server" TextMode="MultiLine" Width="520px" Rows="3"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                        </div>
                    </asp:Panel>
                </div>

                    <!---------------------------->
               <asp:Panel ID="pnTTV" runat="server" Visible="false">
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thẩm tra viên/ Lãnh đạo  
                                <asp:LinkButton ID="lkTTV" runat="server" Text="[ Mở ]"
                                    ForeColor="#0E7EEE" OnClick="lkTTV_Click"></asp:LinkButton>
                        </h4>
                        <div class="boder" style="padding: 10px;">
                           

                                <table class="tableva">
                                        <tr>
                                            <td style="width: 120px;">Ngày phân công</td>
                                            <td style="width: 255px;">
                                                <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                    MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td style="width: 95px;">Thẩm tra viên</td>
                                            <td>
                                                <asp:DropDownList ID="dropTTV"
                                                    AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="250">
                                                </asp:DropDownList>
                                                <span style="margin-left: 10px;">
                                                    <asp:CheckBox ID="chkModify_TTV"  AutoPostBack="true"  runat="server" Text="Thay đổi" OnCheckedChanged="chkChon_CheckedChanged"/></span></td>

                                        </tr>
                                    <tr>
                                        <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo </td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày TTV nhận hồ sơ </td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="2"></td>
                                    </tr>
                                    
                                    <tr>

                                        <td>Lãnh đạo Vụ</td>
                                        <td>
                                            <asp:DropDownList ID="dropLanhDao"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                           
                                        </td>
                                        <td>Thẩm phán</td>
                                        <td>
                                            <asp:DropDownList ID="dropThamPhan"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td  style="padding-top:5px">Ghi chú</td>
                                        <td colspan="3" style="padding-top:5px">
                                            <asp:TextBox ID="txtGhiChu" CssClass="user"
                                                runat="server" Width="605px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                         
                        </div>
                    </div>
           </asp:Panel>


                <div style="margin: 5px; width: 900px; color: red; margin-left: 140px;">
                    <asp:Label ID="lttMsgT" runat="server"></asp:Label>
                </div>
                <div style="margin: 5px; text-align: left; width: 900px; margin-left: 140px; margin-top: 10px;">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                        OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
            </div>
        </div>
    </div>
    <script>
        function LoadThemmoiDon() {

            //if (vuanid > 0)
            //{
                hddVuAnIDchon.value = 0;
                location.reload(true); 
            //}
        }

        function validate() {
            var Drop_LOAI = document.getElementById('<%=Drop_LOAI.ClientID%>');
            value_change = Drop_LOAI.options[Drop_LOAI.selectedIndex].value;
            if (value_change == "") {
                alert("Bạn chưa chọn loại đơn!");
                Drop_LOAI.focus();
                return false;
            }

            //-----------------------------
          
            var txtNgaynhandon = document.getElementById('<%=txtNgaynhandon.ClientID%>');
            if (!CheckDateTimeControl(txtNgaynhandon, "ngày nhận đơn"))
                return false;
        
            var txtNgayghidon = document.getElementById('<%=txtNgayghidon.ClientID%>');
            if (!CheckDateTimeControl(txtNgayghidon, "ngày ghi trên đơn"))
                return false;
        
           
            //----Neu khong chon Bi án có sẵn thì phải Thêm bị án-----------------------------
            var hhdcheckDS = document.getElementById('<%=hhdcheckDS.ClientID%>')
            hhdCheck = hhdcheckDS.value;
            if (hhdCheck == "0") {
                alert("Bạn chưa chọn Bị án! nhấn nút Kiểm tra để hiện danh sách bị án rồi chọn bị án");
                return false
            } else if (hhdCheck == "1") {
                var txtTenbian = document.getElementById('<%=txtBC_HoTen.ClientID%>')
                if (!Common_CheckTextBox(txtTenbian, 'Tên bị án'))
                    return false;
                var txtDiachi = document.getElementById('<%=txtDiachi.ClientID%>')
                if (!Common_CheckTextBox(txtDiachi, 'địa chỉ của bị án'))
                    return false;
                var dropBiCao_ToiDanh = document.getElementById('<%=dropBiCao_ToiDanh.ClientID%>');
                ddltoidanh = dropBiCao_ToiDanh.options[dropBiCao_ToiDanh.selectedIndex].value;
                if (ddltoidanh == "0") {
                    alert("Bạn chưa chọn tội danh!");
                    dropBiCao_ToiDanh.focus();
                    return false;
                }
            }
            <%--//-------TTV - LDV--------------------
            var dropTTV = document.getElementById('<%=dropTTV.ClientID%>');
            ddlTTV_PC = dropTTV.options[dropTTV.selectedIndex].value;
            if (ddlTTV_PC != "0") {
                var txtNgayphancong = document.getElementById('<%=txtNgayphancong.ClientID%>')
                if (!CheckDateTimeControl(txtNgayphancong, 'ngày phân công TTV'))
                    return false;
                var dropLanhDao = document.getElementById('<%=dropLanhDao.ClientID%>');
                ddlLanhDao_PC = dropLanhDao.options[dropLanhDao.selectedIndex].value;
                if (ddlLanhDao_PC == "") {
                    alert("Bạn chưa chọn Lãnh đạo vụ!");
                    dropLanhDao.focus();
                    return false;

                }--%>
            //-------------------------------
            return true;
        }

        function validate_banan_qd() {
            var value_change = "";
            //-----------------------------ddlLoaiBA
            var hddIsAnPT = document.getElementById('<%=hddIsAnPT.ClientID%>');
            if (hddIsAnPT.value == "GDT") {
                <%--var txtSoQĐGDT = document.getElementById('<%=txtSoQĐGDT.ClientID%>');
                if (!Common_CheckTextBox(txtSoQĐGDT, 'Số QĐ Giám đốc thẩm'))
                    return false;--%>
                var txtNgayGDT = document.getElementById('<%=txtNgayGDT.ClientID%>');
                if (!CheckDateTimeControl(txtNgayGDT, "Ngày QĐ Giám đốc thẩm"))
                    return false;
                //-----------------------------
                var dropToaGDT = document.getElementById('<%=dropToaGDT.ClientID%>');
                value_change = dropToaGDT.options[dropToaGDT.selectedIndex].value;
                if (value_change == "0") {
                    alert("Bạn chưa chọn Tòa án ra Quyết định Giám đốc thẩm. Hãy kiểm tra lại!");
                    dropToaGDT.focus();
                    return false;
                }
            }
            else if (hddIsAnPT.value == "PT") {
                <%--var txtSoBA = document.getElementById('<%=txtSoBA.ClientID%>');
                if (!Common_CheckTextBox(txtSoBA, 'Số BA/QĐ phúc thẩm'))
                    return false;--%>
                var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                if (!CheckDateTimeControl(txtNgayBA, "Ngày BA/QĐ phúc thẩm"))
                    return false;
                //-----------------------------
                var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
                value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
                if (value_change == "0") {
                    alert("Bạn chưa chọn Tòa án thụ lý vụ việc phúc thẩm. Hãy kiểm tra lại!");
                    dropToaAn.focus();
                    return false;
                }
            }
            else if (hddIsAnPT.value == "ST") {
               <%-- var txtSoBA_ST = document.getElementById('<%=txtSoBA_ST.ClientID%>');
                if (!Common_CheckTextBox(txtSoBA_ST, 'Số BA/QĐ sơ thẩm'))
                    return false;--%>
                var txtNgayBA_ST = document.getElementById('<%=txtNgayBA_ST.ClientID%>');
                if (!CheckDateTimeControl(txtNgayBA_ST, "Ngày BA/QĐ sơ thẩm"))
                    return false;
                //-----------------------------
                var dropToaAnST = document.getElementById('<%=dropToaAnST.ClientID%>');
                value_change = dropToaAnST.options[dropToaAnST.selectedIndex].value;
                if (value_change == "0") {
                    alert("Bạn chưa chọn Tòa án thụ lý vụ việc  sơ thẩm. Hãy kiểm tra lại!");
                    dropToaAnST.focus();
                    return false;
                }
            }

            //-----------------------------

            return true;
         }

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
