using AutoMapper;
using DominioDenuncia;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceDenuncia;


namespace ServiceDenuncia.Profiles
{
    public class DenunciaProfile : Profile
    {
        public DenunciaProfile()
        {
            // Endereco DTO <-> Entidade
            CreateMap<EnderecoDto, Endereco>()
                .ForMember(d => d.Id, opt => opt.Ignore()); // id gerado pelo db

            CreateMap<Endereco, EnderecoDto>();

            // DenunciaCreateDto -> Denuncia
            CreateMap<DenunciaCreateDto, Denuncia>()
                // Se quer forçar que o servidor defina criadoEm, mantenha; caso contrário, comente essa linha.
                .ForMember(dest => dest.CriadoEm,
                    opt => opt.MapFrom((src, dest) => src.CriadoEm.HasValue ? src.CriadoEm.Value : DateTime.UtcNow))
                .ForMember(dest => dest.Status, opt => opt.MapFrom(_ => DenunciaStatus.Nova))
                // Se Endereco for null no DTO, evita criar um Endereco nulo automaticamente
                .ForMember(dest => dest.Endereco, opt =>
                    opt.Condition(src => src.Endereco != null));

            // Denuncia -> DenunciaDto
            CreateMap<Denuncia, DenunciaDto>()
                .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status.ToString()))
                .ForMember(dest => dest.TipoViolencia, opt => opt.MapFrom(src => src.TipoViolencia.ToString()))
                // Se Endereco for null na entidade, isso preserva null no DTO
                .ForMember(dest => dest.Endereco, opt => opt.Condition(src => src.Endereco != null));

        }
    }
}
